# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="4-python"
PYTHON_DEPEND="<<[xml]>>"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5"
# https://bugs.freedesktop.org/show_bug.cgi?id=52492
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="2.* *-jython"
DISTUTILS_SRC_TEST="nosetests"

inherit distutils

DESCRIPTION="A Python module to deal with freedesktop.org specifications"
HOMEPAGE="http://freedesktop.org/wiki/Software/pyxdg http://cgit.freedesktop.org/xdg/pyxdg/"
SRC_URI="http://people.freedesktop.org/~takluyver/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="examples"

DEPEND=""
RDEPEND=""

DOCS="AUTHORS ChangeLog README TODO"
PYTHON_MODULES="xdg"

src_install() {
	distutils_src_install

	if use examples; then
		docinto examples
		dodoc test/*.py
	fi
}
