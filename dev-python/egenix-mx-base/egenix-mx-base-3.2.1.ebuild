# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="eGenix mx Base Distribution for Python - mxDateTime, mxTextTools, mxProxy, mxTools, mxBeeBase, mxStack, mxQueue, mxURL, mxUID"
HOMEPAGE="http://www.egenix.com/products/python/mxBase http://pypi.python.org/pypi/egenix-mx-base"
SRC_URI="http://downloads.egenix.com/python/${P}.tar.gz"

LICENSE="eGenixPublic-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODULES="mx"

src_prepare() {
	distutils_src_prepare

	# Don't install documentation in site-packages directories.
	sed -e "/\/Doc\//d" -i egenix_mx_base.py || die "sed failed"
}

src_install() {
	distutils_src_install

	dohtml -a html -r mx
	insinto /usr/share/doc/${PF}
	find -iname "*.pdf" | xargs doins

	installation_of_headers() {
		local header
		dodir "$(python_get_includedir)/mx" || return 1
		while read -d $'\0' header; do
			mv -f "${header}" "${ED}$(python_get_includedir)/mx" || return 1
		done < <(find "${ED}$(python_get_sitedir)/mx" -type f -name "*.h" -print0)
	}
	python_execute_function -q installation_of_headers
}
