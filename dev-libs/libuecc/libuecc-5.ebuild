# Copyright 2015 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="Very small Elliptic Curve Cryptography library"
HOMEPAGE="https://projects.universe-factory.net/projects/fastd/wiki"

ATTACHMENT_NUMBER="80"
SRC_URI="https://projects.universe-factory.net/attachments/download/${ATTACHMENT_NUMBER}/${PN}-${PV}.tar.xz"

RESTRICT="mirror"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND=""
DEPEND="${RDEPEND}
		dev-util/cmake
"

S="${WORKDIR}/${P}"

src_prepare() {
	epatch_user
}

src_configure() {
	cmake-utils_src_configure
}
