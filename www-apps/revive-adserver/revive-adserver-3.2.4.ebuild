# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#https://gitweb.gentoo.org/proj/webapps-experimental.git/tree/www-apps/openx/openx-2.4.4.ebuild

EAPI=5
inherit webapp versionator

DESCRIPTION="Advanced web-based ad management"
HOMEPAGE="https://www.revive-adserver.com/"
SRC_URI="https://download.revive-adserver.com/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="+gd +mysqli postgres"

DEPEND="app-arch/unzip
		virtual/cron
		>=dev-lang/php-5.5.9:*[crypt,ctype,gd,session,unicode,xml,zlib]
		|| (
			>=dev-lang/php-5.5.9:*[mysqli]
			>=dev-lang/php-5.5.9:*[postgres]
		)
		mysqli? ( virtual/mysql )
		postgres? ( dev-db/postgresql )
		virtual/httpd-php:*
		"
RDEPEND="${DEPEND}"

WEBAPP_MANUAL_SLOT="yes"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	cp -r . "${D}${MY_HTDOCSDIR}"

	touch "${D}${MY_HTDOCSDIR}"/config.inc.php
	webapp_configfile "${MY_HTDOCSDIR}"/config.inc.php
	webapp_serverowned "${MY_HTDOCSDIR}"/config.inc.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	
	for dir in var var/cache var/plugins var/templates_compiled plugins www/admin/plugins www/images ; do
		webapp_serverowned "${MY_HTDOCSDIR}"/${dir}
	done
	webapp_src_install
}

pkg_postinst() {
	if ! use gd ; then
		ewarn "If you would like to have support for displaying graphs in the ${PN}"
		ewarn "statistics pages, you will also need to make sure that PHP is installed"
		ewarn "with support for GD."
	fi
	webapp_pkg_postinst
}
