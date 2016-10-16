# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils

DESCRIPTION="Very small Elliptic Curve Cryptography library"
HOMEPAGE="https://projects.universe-factory.net/projects/fastd/wiki"

SRC_URI="https://git.universe-factory.net/${PN}/snapshot/${PN}-${PV}.zip"

RESTRICT="mirror"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND=""
DEPEND="${RDEPEND}
		dev-util/cmake
"

S="${WORKDIR}/${P}"

src_configure() {
	cmake-utils_src_configure
}
