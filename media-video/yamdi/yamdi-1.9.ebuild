# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit base eutils

DESCRIPTION="Yet Another Metadata Injector for FLV."
HOMEPAGE="http://yamdi.sourceforge.net/"
SRC_URI="mirror://sourceforge/yamdi/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"

IUSE="user-defined"


RDEPEND="${DEPEND}"

src_prepare() {
	einfo "Remove dos symbols from yamdi.c"
	sed -i 's///' ${WORKDIR}/${P}/yamdi.c || die "sed failed"
	if use user-defined; then
		einfo "Patch yamdi_user_defined_tags.patch"
		epatch "${FILESDIR}"/yamdi_user_defined_tags.patch || die "epatch yamdi_user_defined_tags.patch failed"
	fi
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	dobin yamdi
}
