# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.4 2.5 3.* *-jython"
PYTHON_NAMESPACES="+infrae +silva +silva.core"

inherit python-namespaces

KEYWORDS="~amd64 ~x86"
