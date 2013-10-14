# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3

EAPI=4

inherit git-2 eutils

DESCRIPTION="Casperjs"
HOMEPAGE="http://casperjs.org/"
EGIT_REPO_URI="git://github.com/n1k0/casperjs.git"
EGIT_COMMIT="tags/${PV}"

LICENSE="|| ( LGPL-3 )"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=www-client/phantomjs-1.8.0
"
RDEPEND="${DEPEND}"

src_install(){
	dodir /usr/share/${P}/
	cp -R "${S}/" "${D}/usr/share/" || die
	dodir /usr/bin/
	ln -s /usr/share/${P}/bin/casperjs ${D}/usr/bin/casperjs || die
}
