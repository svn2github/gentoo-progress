# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_DEPEND="python? ( <<>> )"
PYTHON_MULTIPLE_ABIS="1"
# http://bugs.jython.org/issue1916
PYTHON_RESTRICTED_ABIS="*-jython"

inherit distutils eutils libtool toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/glensc/file.git"
	inherit autotools git-r3
else
	SRC_URI="ftp://ftp.astron.com/pub/file/${P}.tar.gz
		ftp://ftp.gw.com/mirrors/pub/unix/file/${P}.tar.gz"
	KEYWORDS="*"
fi

DESCRIPTION="identify a file's format by scanning binary data for patterns"
HOMEPAGE="http://www.darwinsys.com/file/"

LICENSE="BSD-2"
SLOT="0"
IUSE="python static-libs zlib"

DEPEND="zlib? ( sys-libs/zlib:0= )"
RDEPEND="${DEPEND}
	python? ( !!dev-python/python-magic )"

PYTHON_MODULES="magic.py"

pkg_setup() {
	use python && python_pkg_setup
}

src_prepare() {
	[[ ${PV} == "9999" ]] && eautoreconf
	elibtoolize

	# don't let python README kill main README #60043
	mv python/README{,.python}

	# https://github.com/file/file/commit/e14d88d8df2aafb74ba0c0b3d0116fc84b68cbd8
	sed -e "s/bi = bytes(filename, 'utf-8')/bi = filename if isinstance(filename, bytes) else bytes(filename, 'utf-8')/" -i python/magic.py
}

wd() { echo "${WORKDIR}"/build-${CHOST}; }

do_configure() {
	ECONF_SOURCE=${S}

	mkdir "$(wd)"
	pushd "$(wd)" >/dev/null

	econf "$@"

	popd >/dev/null
}

src_configure() {
	# when cross-compiling, we need to build up our own file
	# because people often don't keep matching host/target
	# file versions #362941
	if tc-is-cross-compiler && ! ROOT=/ has_version ~${CATEGORY}/${P} ; then
		tc-export_build_env BUILD_C{C,XX}
		ac_cv_header_zlib_h=no \
		ac_cv_lib_z_gzopen=no \
		CHOST=${CBUILD} \
		CFLAGS=${BUILD_CFLAGS} \
		CXXFLAGS=${BUILD_CXXFLAGS} \
		CPPFLAGS=${BUILD_CPPFLAGS} \
		LDFLAGS="${BUILD_LDFLAGS} -static" \
		CC=${BUILD_CC} \
		CXX=${BUILD_CXX} \
		do_configure --disable-shared
	fi

	export ac_cv_header_zlib_h=$(usex zlib) ac_cv_lib_z_gzopen=$(usex zlib)
	do_configure $(use_enable static-libs static)
}

do_make() {
	emake -C "$(wd)" "$@"
}

src_compile() {
	if tc-is-cross-compiler && ! ROOT=/ has_version ~${CATEGORY}/${P} ; then
		CHOST=${CBUILD} do_make -C src file
		PATH=$(CHOST=${CBUILD} wd)/src:${PATH}
	fi
	do_make

	use python && cd python && distutils_src_compile
}

src_install() {
	do_make DESTDIR="${D}" install
	dodoc ChangeLog MAINT README

	use python && cd python && distutils_src_install
	prune_libtool_files
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
