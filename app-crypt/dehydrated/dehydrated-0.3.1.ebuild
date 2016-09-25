# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

# Based on ebuild by Jonathan Vasquez <jvasquez1011@gmail.com>

EAPI=5

inherit user systemd

GITHUB_USER="lukas2511"
GITHUB_REPO="${PN}"
GITHUB_TAG="${PV}"

DESCRIPTION="Let's Encrypt - ACME Client"
HOMEPAGE="https://github.com/lukas2511/dehydrated"

SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/v${GITHUB_TAG}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="dev-libs/openssl
sys-apps/sed
sys-apps/grep
sys-apps/coreutils
sys-apps/diffutils
net-misc/curl
"
src_install() {
	elog "$(ls)"
	dobin "${PN}"
	dodoc CHANGELOG README.md
    dodoc -r docs
}
