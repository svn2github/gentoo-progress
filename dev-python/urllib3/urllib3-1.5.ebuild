# Copyright owners: Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.6 3.1 *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more."
HOMEPAGE="http://urllib3.readthedocs.org/ https://github.com/shazow/urllib3 http://pypi.python.org/pypi/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

RDEPEND="$(python_abi_depend dev-python/six)"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	test? ( $(python_abi_depend -e "3.1 *-jython" www-servers/tornado) )"

DOCS="CHANGES.rst CONTRIBUTORS.txt README.rst"

src_prepare() {
	distutils_src_prepare

	# Do not install dummyserver.
	sed -e "s/, 'dummyserver'//" -i setup.py

	# Use system version of dev-python/six.
	sed \
		-e "s/from .packages import six/import six/" \
		-e "s/from .packages.six import/from six import/" \
		-i urllib3/*.py
	sed \
		-e "s/from urllib3.packages import six/import six/" \
		-e "s/from urllib3.packages.six import/from six import/" \
		-i test/*.py
	rm -f urllib3/packages/six.py
}
