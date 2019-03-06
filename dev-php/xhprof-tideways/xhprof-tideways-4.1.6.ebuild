# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PHP_EXT_NAME="xhprof"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_S="${WORKDIR}/${P}/extension"

USE_PHP="php5-4 php5-5 php5-6"

inherit webapp php-ext-source-r2 git-r3 php-ext-pecl-r2

HOMEPAGE="http://pecl.php.net/package/xhprof"
KEYWORDS="~amd64 ~x86"
DESCRIPTION="A Hierarchical Profiler for PHP"
LICENSE="Apache-2.0"

EGIT_REPO_URI="https://github.com/phacility/xhprof.git"
EGIT_BRANCH="master"

#SLOT="0"
#WEBAPP_MANUAL_SLOT="yes"
IUSE=""

WEBAPPS_DIR="/usr/share/webapps"

DEPEND="media-gfx/graphviz"
RDEPEND="${DEPEND}
		dev-lang/php
		"

src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		cp -r "${WORKDIR}/${P}/extension" "${WORKDIR}/${slot}"
		php_init_slot_env ${slot}
		php-ext-source-r2_phpize
	done
}

#pkg_setup() {
#	einfo PKG_SETUP 
#	webapp_pkg_setup
#}

src_install() {
	einfo SRC_INSTALL
    #webapp_src_preinst
	#php-ext-source-r2_src_install
	#php-ext-source-r2_addtoinifiles "xhprof.output_dir" "/tmp"
	#dodir "${WEBAPPS_DIR}/${PN}/${PVR}"
	#cd "${S}/xhprof_html"
	#insinto "${MY_HTDOCSDIR}"
	#doins -r *
	#cd "${S}"
	#dodir "/usr/share/php5/xhprof"
	#insinto "/usr/share/php5/xhprof"
	#doins -r xhprof_lib
	#dosym "/usr/share/php5/xhprof/xhprof_lib" "${MY_HOSTROOTDIR}/htdocs/xhprof_lib"
    webapp_src_install
}
