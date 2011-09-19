# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 3.* *-jython"

inherit distutils eutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Zope Page Templates"
HOMEPAGE="http://pypi.python.org/pypi/zope.pagetemplate"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="$(python_abi_depend net-zope/namespaces-zope[zope])
	$(python_abi_depend net-zope/zope-component)
	$(python_abi_depend net-zope/zope-i18n)
	$(python_abi_depend net-zope/zope-i18nmessageid)
	$(python_abi_depend net-zope/zope-interface)
	$(python_abi_depend net-zope/zope-security)
	$(python_abi_depend net-zope/zope-tal)
	$(python_abi_depend net-zope/zope-tales)
	$(python_abi_depend net-zope/zope-traversing)"
DEPEND="${RDEPEND}
	app-arch/unzip
	$(python_abi_depend dev-python/setuptools)"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt"
PYTHON_MODULES="${PN/-//}"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-_v_macros.patch"
}
