# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_DEPEND="<<[xml]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 3.*"

inherit distutils eutils

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_VERSIONED_SCRIPTS=("/usr/lib(32|64)?/${PN}/bin/.*")
PYTHON_MODULES="javatoolkit"

src_prepare(){
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-python2.6.patch"
	epatch "${FILESDIR}/${P}-no-pyxml.patch"
}

src_install() {
	distutils_src_install --install-scripts="/usr/$(get_libdir)/${PN}/bin"
}
