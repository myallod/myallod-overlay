# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/rtorrent/rtorrent-0.9.4-r1.ebuild,v 1.3 2015/05/08 14:31:42 jlec Exp $

EAPI=5

inherit autotools eutils systemd git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="http://libtorrent.rakshasa.no/"
EGIT_REPO_URI="https://github.com/rakshasa/rtorrent.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="color daemon debug ipv6 selinux test xmlrpc"

COMMON_DEPEND="~net-libs/libtorrent-9999
	dev-util/cppunit
	>=dev-libs/libsigc++-2.2.2:2
	>=net-misc/curl-7.19.1
	sys-libs/ncurses
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-util/cppunit )
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_prepare() {
	# bug #358271
	epatch \
		"${FILESDIR}"/${P}-ncurses.patch \
		"${FILESDIR}"/${P}-tinfo.patch
	
	if use color; then
		epatch "${FILESDIR}"/${P}-color.patch
	fi

	# upstream forgot to include
	cp "${FILESDIR}"/rtorrent.1 "${S}"/doc/ || die

	eautoreconf
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default
	doman doc/rtorrent.1

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
		systemd_newunit "${FILESDIR}/rtorrentd_at.service" "rtorrentd@.service"
	fi
}

pkg_postinst() {
	if use color; then
	  cat << "EOF"
==>
==> Set colors using the options below in .rtorrent.rc:
==> Options: color_inactive_fg, color_inactive_bg, color_dead_fg, color_dead_bg, 
==>          color_active_fg, color_active_bg, color_finished_fg, color_finished_bg, 
==>
==> Colors: 0 = black 1 = red 2 = green 3 = yellow 4 = blue 5 = magenta 6 = cyan 7 = white
==>
==> Nice example-config: color_inactive_fg = 4
==>                      color_dead_fg = 1
==>                      color_active_fg = 3
==>                      color_finished_fg = 2
==>
==> Explanation:
==>  Inactive: Deactivated torrent
==>  Dead:     Active but can't find seeders
==>  Active:   Active and downloading
==>  Finished: Download done
==>  If the torrent is highlighted (using bold text) you're uploading data
==>
EOF
	fi
}
