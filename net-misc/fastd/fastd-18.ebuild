# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

DESCRIPTION="fastd is a Fast and Secure Tunneling Daemon"
HOMEPAGE="https://projects.universe-factory.net/projects/fastd/wiki"

SRC_URI="https://git.universe-factory.net/${PN}/snapshot/${PN}-${PV}.zip"

RESTRICT="mirror"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="lto nacl openssl"

RDEPEND="
		sys-libs/libcap
		>=dev-libs/libuecc-6
		!nacl? ( dev-libs/libsodium )
		openssl? ( dev-libs/openssl:* )
		dev-libs/json-c
"
DEPEND="${RDEPEND}
		dev-ruby/pkg-config
		>=sys-devel/bison-2.5
		dev-util/cmake
"

S="${WORKDIR}/${P}"

src_prepare() {
    eapply_user

	cmake-utils_src_prepare

	tail -n 1 "${S}/README" > "${S}/README.new"
	mv "${S}/README.new" "${S}/README"
}

src_configure() {
	local mycmakeargs=(
		cmake-utils_use_enable lto LTO
		cmake-utils_use_enable nacl LIBSODIUM
		cmake-utils_use_enable openssl OPENSSL
	)
	cmake-utils_src_configure
}

src_install() {
	doman doc/fastd.1
	dodoc README
	newinitd "${FILESDIR}/fastd-0.17.initd" fastd
	keepdir /etc/fastd

	cmake-utils_src_install
}
