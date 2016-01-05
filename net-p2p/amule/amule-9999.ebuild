# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# http://wiki.amule.org/t/index.php?title=HowTo_Compile_In_Gentoo
# http://amule.forumer.com/topic/2313305/gentoo-live-ebuild-for-amule
# http://amule.sourceforge.net/tarballs/tarballs.xml
# http://repo.or.cz/w/amule.git/refs

EAPI="5"

inherit user flag-o-matic kde4-base wxwidgets git-r3

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="http://www.amule.org/"
EGIT_REPO_URI="https://github.com/amule-project/amule.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="asio daemon debug ed2k fileview geoip gtk mmap nls plasma remote static stats unicode upnp xchat"

RESTRICT="nomirror"

DEPEND="=x11-libs/wxGTK-2.8.12*
	>=dev-libs/crypto++-5
	>=sys-libs/zlib-1.2.1
	sys-devel/autoconf
	>=sys-devel/automake-1.9
	asio? ( dev-libs/boost )
	stats? ( >=media-libs/gd-2.0.26[jpeg] )
	geoip? ( dev-libs/geoip )
	upnp? ( >=net-libs/libupnp-1.6.6 )
	remote? ( >=media-libs/libpng-1.2.0
	unicode? ( >=media-libs/gd-2.0.26 ) )
	plasma? ( kde-base/kdelibs:4 )"

RDEPEND="${DEPEND}
		xchat? ( net-irc/xchat[perl] )"

REQUIRED_USE="|| ( gtk remote daemon )"

pkg_setup() {
	if ! use gtk && ! use remote && ! use daemon; then
		eerror ""
		eerror "You have to specify at least one of gtk, remote or daemon"
		eerror "USE flag to build amule."
		eerror ""
		die "Invalid USE flag set"
	fi

	if use stats && ! use gtk; then
		einfo "Note: You would need both the X and stats USE flags"
		einfo "to compile aMule Statistics GUI."
		einfo "I will now compile console versions only."
	fi
}

pkg_preinst() {
	if use daemon || use remote; then
		enewgroup p2p
		enewuser p2p -1 -1 /home/p2p p2p
	fi
}

src_configure() {
	local myconf

	WX_GTK_VER="2.8"

	if use gtk; then
		einfo "wxGTK with gtk support will be used"
		need-wxwidgets unicode
	else
		einfo "wxGTK without X support will be used"
		need-wxwidgets base
	fi

	if use gtk ; then
		use stats && myconf="${myconf}
			--enable-wxcas
			--enable-alc"
		use remote && myconf="${myconf}
			--enable-amule-gui"
	else
		myconf="
			--disable-monolithic
			--disable-amule-gui
			--disable-wxcas
			--disable-alc"
	fi

	bash autogen.sh

	econf \
		--with-wx-config=${WX_CONFIG} \
		--enable-amulecmd \
		$(use_with asio boost) \
		$(use_enable debug) \
		$(use_enable !debug optimize) \
		$(use_enable daemon amule-daemon) \
		$(use_enable ed2k) \
		$(use_enable fileview) \
		$(use_enable geoip) \
		$(use_enable mmap) \
		$(use_enable nls) \
		$(use_enable plasma plasmamule) \
		$(use_enable remote webserver) \
		$(use_enable static) \
		$(use_enable stats cas) \
		$(use_enable stats alcc) \
		$(use_enable upnp) \
		$(use_enable xchat xas) \
		${myconf} || die

}

src_compile() {
	cd ${S}
	emake
}

src_install() {
	emake DESTDIR="${D}" install || die

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi
}
