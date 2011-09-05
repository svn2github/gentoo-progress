# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"
DISTUTILS_SRC_TEST="trial"
DISTUTILS_DISABLE_TEST_DEPENDENCY="1"

inherit distutils

DESCRIPTION="RPC protocol for Twisted"
HOMEPAGE="http://foolscap.lothar.com/trac http://pypi.python.org/pypi/foolscap"
SRC_URI="http://${PN}.lothar.com/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc ssl"

RDEPEND="$(python_abi_depend ">=dev-python/twisted-2.4.0")
	$(python_abi_depend dev-python/twisted-web)
	ssl? ( $(python_abi_depend dev-python/pyopenssl) )"
DEPEND="${DEPEND}
	$(python_abi_depend dev-python/setuptools)"

src_prepare() {
	distutils_src_prepare

	# Disable test failing with dev-python/pyopenssl and dev-libs/openssl-1.
	sed -e "s/test_generate/_&/" -i foolscap/test/test_tub.py
}

src_test() {
	LC_ALL="C" distutils_src_test
}

src_install() {
	distutils_src_install

	if use doc; then
		dodoc doc/*.txt
		dohtml -A py,tpl,xhtml -r doc/*
	fi
}
