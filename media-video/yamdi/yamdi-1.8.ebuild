# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Yet Another MetaData Injector is a metadata injector for FLV files"
HOMEPAGE="http://yamdi.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/yamdi/files/yamdi/${PV}/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	return
}

src_install() {
	dodoc README CHANGES
	doman man1/yamdi.1
	
	dobin yamdi
}
