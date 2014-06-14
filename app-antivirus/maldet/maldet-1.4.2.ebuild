# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/clamav/clamav-0.97.4.ebuild,v 1.1 2012/03/16 21:25:46 radhermit Exp $

EAPI=4

DESCRIPTION="Linux Malware Detect (LMD) is a malware scanner for Linux released under the GNU GPLv2 license"
HOMEPAGE="http://www.rfxn.com/projects/linux-malware-detect/"
SRC_URI="http://www.rfxn.com/downloads/maldetect-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="inotify"
RDEPEND="inotify? ( sys-fs/inotify-tools )"

src_unpack() {
    unpack ${A}
    S="${WORKDIR}/maldetect-${PV}"
}

src_prepare() {
    sed -i -e	's#inspath=/usr/local/maldetect#inspath=/var/maldet#' \
	-e	's#conf.maldet#maldet.conf#g' \
	-e	's#cnf=$inspath/#cnf=/etc/maldet/#' \
	-e	's#tmp_inspath=/usr/local/lmd_update#tmp_inspath=/tmp/maldet_update#' \
	-e	's#$inspath/maldet#/usr/sbin/maldet#g' \
	-e	"s#lmdup() {#lmdup() {\necho 'Use portage to update this!'\nexit 1#" \
		'files/maldet' || die

    sed -i -e 	's#ignore_paths=$inspath/ignore_paths#ignore_paths=/etc/maldet/ignore_paths#' \
	-e	's#ignore_sigs=$inspath/ignore_sigs#ignore_sigs=/etc/maldet/ignore_sigs#' \
	-e	's#ignore_inotify=$inspath/ignore_inotify#ignore_inotify=/etc/maldet/ignore_inotify#' \
	-e	's#ignore_file_ext=$inspath/ignore_file_ext#ignore_file_ext=/etc/maldet/ignore_file_ext#' \
	-e	's#tmpdir=$inspath/tmp#tmpdir=/tmp#' \
	-e	's#tlog=$inspath/inotify/tlog#tlog=/usr/libexec/maldet/tlog#' \
	-e	's#hexm_pl=$inspath/hexstring.pl#hexm_pl=/usr/libexec/maldet/hexstring.pl#' \
	-e	's#hexmfifo_pl=$inspath/hexfifo.pl#hexmfifo_pl=/usr/libexec/maldet//hexfifo.pl#' \
	-e 	's#logf=$inspath/event_log#logf=/var/log/maldet.log#' \
	-e	's#inotify=$inspath/inotify/inotifywait#inotify=/usr/bin/inotifywait#' \
		'files/internals.conf' || die
    sed -i -e	's#/usr/local/maldetect/#/var/maldet/#g' \
		'files/hexfifo.pl' || die
    sed -i -e	's#/usr/local/maldetect/#/var/maldet/#g' \
		'files/hexstring.pl' || die
    true;
}

src_install() {
    insinto /etc/maldet || die
    newins files/conf.maldet maldet.conf || die 
    doins files/ignore_file_ext || die
    doins files/ignore_inotify || die
    doins files/ignore_paths || die
    doins files/ignore_sigs || die
    doins files/internals.conf || die

    insinto /usr/libexec/maldet || die
    doins files/hexfifo.pl || die
    doins files/hexstring.pl || die
    doins files/inotify/tlog || die
    
    dodir /var/maldet || die
    dodir /var/maldet/clean || die
    dodir /var/maldet/quarantine || die
    dodir /var/maldet/sess || die
    dodir /var/maldet/sigs || die
    dodir /var/maldet/inotify || die
    insinto /var/maldet/sigs || die
    doins files/sigs/* || die
    
    insinto /var/maldet/clean || die
    doins files/clean/* || die
    
    dosbin files/maldet || die
    dodoc README || die
    dodoc CHANGELOG || die
}