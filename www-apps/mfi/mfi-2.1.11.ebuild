# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="mFi M2M Management software solution"
HOMEPAGE="https://www.ubnt.com/download/mfi"
SRC_URI="https://dl.ubnt.com/mfi/${PV}/mFi.unix.zip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/jre:1.7
	www-servers/tomcat"
