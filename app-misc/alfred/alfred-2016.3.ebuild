# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils linux-info

DESCRIPTION="alfred is a user space daemon to efficiently[tm] flood the network with useless data - like vis, weather data, network notes, etc"
HOMEPAGE="https://www.open-mesh.org/projects/alfred/wiki"

SRC_URI="https://downloads.open-mesh.org/batman/stable/sources/${PN}/${PN}-${PV}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="alfred-vis caps"

RDEPEND="
		>=dev-libs/libnl-3
		sys-libs/libcap
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

pkg_setup() {
	if ( linux_config_exists && linux_chkconfig_present CONFIG_IPV6 ); then
		ewarn "You need IPv6 support in Kernel."
	fi
}

src_prepare() {
	sed -i "s|PREFIX =|PREFIX := |" "${S}/Makefile"
	default
}

src_compile() {
	MKOPT="CONFIG_ALFRED_GPSD=n"
	use alfred-vis || MKOPT="${MKOPT} CONFIG_ALFRED_VIS=n"
	use caps || MKOPT="${MKOPT} CONFIG_ALFRED_CAPABILITIES=n"

	emake ${MKOPT} || die "emake failed";
}

src_install() {
	MKOPT="CONFIG_ALFRED_GPSD=n"
	use alfred-vis || MKOPT="${MKOPT} CONFIG_ALFRED_VIS=n"
	use caps || MKOPT="${MKOPT} CONFIG_ALFRED_CAPABILITIES=n"

	emake ${MKOPT} PREFIX=/usr DESTDIR="${D}" install || die "emake install failed";

	doman man/${PN}.8
	dodoc CHANGELOG README

	newinitd "${FILESDIR}/alfred-2016.3.initd" alfred
}
