# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib eutils

DESCRIPTION="Convert html to pdf (and various image formats) using webkit - static precompiled version"
HOMEPAGE="http://wkhtmltopdf.org/ https://github.com/wkhtmltopdf/wkhtmltopdf/ http://wkhtmltopdf.org/downloads.html"
SRC_URI="amd64? ( https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/${PV}/wkhtmltox-${PV}_linux-generic-amd64.tar.xz )
		x86? ( https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/${PV}/wkhtmltox-${PV}_linux-generic-i386.tar.xz )"

UNPACKDIR="wkhtmltox"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxmlpatterns:5
	!media-gfx/wkhtmltopdf"
DEPEND="${RDEPEND}"

#	dev-qt/qtprintsupport:5
#	dev-qt/qtwebkit:5[printsupport]

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
