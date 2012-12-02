# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"
PYTHON_TESTS_RESTRICTED_ABIS="3.1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"

inherit distutils virtualx

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="http://www.pygame.org/"
if [[ "${PV}" == *_pre* ]]; then
	SRC_URI="http://people.apache.org/~Arfrever/gentoo/${P}.tar.xz"
else
	SRC_URI="http://www.pygame.org/ftp/pygame-${PV}release.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc sparc x86 ~x86-fbsd"
IUSE="doc examples X"

DEPEND="$(python_abi_depend dev-python/numpy)
	media-libs/freetype:2
	media-libs/sdl-image[png,jpeg]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/smpeg
	X? ( media-libs/libsdl[X,video] )
	!X? ( media-libs/libsdl )"
RDEPEND="${DEPEND}"

if [[ "${PV}" != *_pre* ]]; then
	S="${WORKDIR}/${P}release"
fi

PYTHON_CFLAGS=("2.* + -fno-strict-aliasing")

DOCS="WHATSNEW"

src_configure() {
	"$(PYTHON -f)" config.py -auto

	if ! use X; then
		sed -e "s:^scrap :#&:" -i Setup || die "sed failed"
	fi

	# Disable automagic dependency on PortMidi.
	sed -e "s:^pypm :#&:" -i Setup || die "sed failed"

	# Restore pygame.movie module.
	sed -e "s:^#movie :movie :" -i Setup || die "sed failed"
}

src_test() {
	testing() {
		python_execute PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib*)" "$(PYTHON)" run_tests.py
	}
	VIRTUALX_COMMAND="python_execute_function" virtualmake testing
}

src_install() {
	distutils_src_install

	delete_examples_and_tests() {
		rm -fr "${ED}$(python_get_sitedir)/pygame/examples"
		rm -fr "${ED}$(python_get_sitedir)/pygame/tests"
	}
	python_execute_function -q delete_examples_and_tests

	if use doc; then
		dohtml -r docs/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
