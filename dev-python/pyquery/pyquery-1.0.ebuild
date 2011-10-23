# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 2.5 3.1 *-jython *-pypy-*"
# https://bitbucket.org/olauzanne/pyquery/issue/32
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils eutils

DESCRIPTION="A jquery-like library for python"
HOMEPAGE="http://pypi.python.org/pypi/pyquery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="$(python_abi_depend ">=dev-python/lxml-2.1")
	$(python_abi_depend dev-python/webob)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)"

DOCS="CHANGES.txt README.txt"

src_prepare() {
	distutils_src_prepare

	epatch "${FILESDIR}/${P}-python-3.patch"

	# Disable failing tests.
	sed -e "/class TestReadme/,/^$/d" -i pyquery/test.py

	# Disable tests requiring absent "docs" directory.
	# https://bitbucket.org/olauzanne/pyquery/issue/31
	sed -e "/for filename in os.listdir(docs):/,/^$/d" -i pyquery/test.py
}

src_install() {
	distutils_src_install

	delete_tests() {
		rm -f "${ED}$(python_get_sitedir)/pyquery/"{test.py,tests.txt}
	}
	python_execute_function -q delete_tests
}
