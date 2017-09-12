# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs pax-utils multiprocessing qmake-utils

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
SRC_URI="https://github.com/ariya/phantomjs/archive/${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	dev-libs/glib
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# Vanilla QtWebkit:5 does not support WebSecurityEnabled in QWebSettings
	sed -r \
		-e '/QWebSettings::WebSecurityEnabled/d' \
		-i src/webpage.cpp

	default
}

src_configure() {
	eqmake5
}

src_test() {
	./bin/phantomjs test/run-tests.js || die
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
