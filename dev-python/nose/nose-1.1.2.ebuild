# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="*-jython"

inherit distutils eutils

DESCRIPTION="nose extends unittest to make testing easier"
HOMEPAGE="http://pypi.python.org/pypi/nose http://readthedocs.org/docs/nose/ https://bitbucket.org/jpellerin/nose/ http://code.google.com/p/python-nose/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc examples test"

RDEPEND="$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-0.6 )
	test? ( $(python_abi_depend -e "3.* *-jython" dev-python/twisted) )"

DOCS="AUTHORS"

src_prepare() {
	distutils_src_prepare

	# Disable usage of sphinx.ext.intersphinx, which requires network connection.
	epatch "${FILESDIR}/${PN}-0.11.0-disable_intersphinx.patch"

	# Disable tests requiring network connection.
	sed \
		-e "s/test_resolve/_&/g" \
		-e "s/test_raises_bad_return/_&/g" \
		-e "s/test_raises_twisted_error/_&/g" \
		-i unit_tests/test_twisted.py || die "sed failed"

	# Disable versioning of nosetests script to avoid collision with versioning performed by python_merge_intermediate_installation_images().
	sed -e "/'nosetests%s = nose:run_exit' % py_vers_tag,/d" -i setup.py || die "sed failed"
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		if [[ "$(python_get_version --major)" == "3" ]]; then
			rm -fr build || return 1
			"$(PYTHON)" setup.py build_tests || return 1
		fi

		"$(PYTHON)" setup.py egg_info || return 1
		"$(PYTHON)" selftest.py -v
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install --install-data "${EPREFIX}/usr/share"

	python_generate_wrapper_scripts -E -f -q "${ED}usr/bin/nosetests"

	if use doc; then
		pushd doc/.build/html > /dev/null
		insinto /usr/share/doc/${PF}/html
		doins -r [a-z]* _static
		popd > /dev/null
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
