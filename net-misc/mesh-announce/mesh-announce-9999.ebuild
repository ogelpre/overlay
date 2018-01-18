# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="freifunk frickelfoo"
HOMEPAGE="https://github.com/ffnord/mesh-announce"

EGIT_REPO_URI="https://github.com/ffnord/mesh-announce.git"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="
        >=dev-lang/python-3
"
DEPEND="${RDEPEND}
"

S="${WORKDIR}/${P}"

src_install() {
        dodoc README.md
#        newinitd "${FILESDIR}/fastd-0.17.initd" fastd

        exeinto /usr/local/${PN}
        doexe respondd.py
        doexe gather.py
        insinto /usr/local/${PN}
        doins -r neighbours.d
        doins -r statistics.d
}

