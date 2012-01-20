# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"
PYTHON_TESTS_RESTRICTED_ABIS="2.4 2.5"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

inherit eutils python

DESCRIPTION="Python bindings for the D-Bus messagebus"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/DBusBindings http://dbus.freedesktop.org/doc/dbus-python/"
SRC_URI="http://dbus.freedesktop.org/releases/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND=">=dev-libs/dbus-glib-0.88
	>=sys-apps/dbus-1.4.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( $(python_abi_depend "=dev-python/epydoc-3*") )
	test? ( $(python_abi_depend -e "2.4 2.5" dev-python/pygobject:2) )"

src_prepare() {
	python_clean_py-compile_files

	# Work around test suite issues.
	epatch "${FILESDIR}/${PN}-0.83.1-workaround-broken-test.patch"

	# Simple sed to avoid an eautoreconf
	# bug #363679, https://bugs.freedesktop.org/show_bug.cgi?id=43735
	sed -e 's/\(RST2HTMLFLAGS=\)$/\1--input-encoding=UTF-8/' \
		-i configure || die "sed failed"

	python_src_prepare
}

src_configure() {
	configuration() {
		econf \
			--docdir="${EPREFIX}/usr/share/doc/${PF}" \
			$(use_enable doc api-docs)
	}
	python_execute_function -s configuration
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	python_src_test
}

src_install() {
	python_src_install

	if use doc; then
		install_documentation() {
			dohtml api/*
		}
		python_execute_function -f -q -s install_documentation
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples
	fi

	python_clean_installation_image
}

pkg_postinst() {
	python_mod_optimize dbus dbus_bindings.py
}

pkg_postrm() {
	python_mod_cleanup dbus dbus_bindings.py
}
