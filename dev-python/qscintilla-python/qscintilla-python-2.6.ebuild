# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit eutils python toolchain-funcs

MY_P="QScintilla-gpl-${PV/_pre/-snapshot-}"

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/qscintilla/intro"
SRC_URI="http://www.riverbankcomputing.co.uk/static/Downloads/QScintilla2/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="debug"

DEPEND="$(python_abi_depend ">=dev-python/sip-4.10")
	$(python_abi_depend ">=dev-python/PyQt4-4.7[X]")
	~x11-libs/qscintilla-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/Python"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.5.1-disable_stripping.patch"

	python_copy_sources
}

src_configure() {
	configuration() {
		local myconf=("$(PYTHON)"
			configure.py
			-p 4
			--destdir="${EPREFIX}$(python_get_sitedir)/PyQt4"
			$(use debug && echo --debug))
		python_execute "${myconf[@]}"
	}
	python_execute_function -s configuration
}

src_compile() {
	building() {
		emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINK="$(tc-getCXX)"
	}
	python_execute_function -s building
}
