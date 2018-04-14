# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib eutils pax-utils

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
SRC_URI="amd64? ( https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 )
         x86? ( https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-i686.tar.bz2 )"

UNPACKDIR="phantomjs-2.1.1-linux-x86_64"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	dev-libs/glib
	!www-client/phantomjs
"
#	dev-qt/qtcore:5
#	dev-qt/qtgui:5
#	dev-qt/qtnetwork:5
#	dev-qt/qtwebkit:5
#	dev-qt/qtwidgets:5
#"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/${UNPACKDIR}"
}

src_install() {
	pax-mark m bin/phantomjs || die
	dobin bin/phantomjs
	dodoc ChangeLog README.md
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}
