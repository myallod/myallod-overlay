# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2 multilib eutils

DESCRIPTION="Convert html to pdf (and various image formats) using webkit - static precompiled version"
HOMEPAGE="http://wkhtmltopdf.org/ https://github.com/wkhtmltopdf/wkhtmltopdf/ http://wkhtmltopdf.org/downloads.html"
SRC_URI="amd64? ( http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz )
		x86? ( http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-i386.tar.xz )"

UNPACKDIR="wkhtmltox"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtcore:4
	dev-qt/qtsvg:4
	dev-qt/qtxmlpatterns:4
	!media-gfx/wkhtmltopdf"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/${UNPACKDIR}"
}

src_install() {
	exeinto /usr/bin
	dobin bin/wkhtmltopdf
	dobin bin/wkhtmltoimage

	dolib.so lib/libwkhtmltox.so.${PV}
	local v
	cd lib
	for v in libwkhtmltox.so{,.{${PV%%.*},${PV%.*}}}; do
		dosym libwkhtmltox.so.${PV} /usr/$(get_libdir)/${v}
	done

	cd ${S}
	doman share/man/man1/*.1.gz

	insinto /usr/include/wkthmltox
	doins include/wkhtmltox/*
}
