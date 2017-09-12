# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

# Based on ebuild by Jonathan Vasquez <jvasquez1011@gmail.com>

EAPI=6

GITHUB_USER="${PN}"
GITHUB_REPO="${PN}"

EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}/..."

EGIT_COMMIT="54c79c564870bf4b36ce630e93513f485e598ab8"
ARCHIVE_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

inherit user golang-vcs-snapshot

#TODO: USER

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="http://grafana.org"
SRC_URI="${ARCHIVE_URI}"

RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""
DEPEND=">=dev-lang/go-1.8.3
        net-libs/nodejs
        sys-apps/yarn"
RDEPEND="!<dev-lang/go-1.8.3"

SRC_DIR="${WORKDIR}/${P}/src/${EGO_PN%...}"
S="${SRC_DIR}"

src_prepare() {
   default
   pushd "${S}/conf" >/dev/null
   mv sample.ini grafana.ini
   sed -i '/;reporting_enabled = true/reporting_enabled = false/' grafana.ini
   popd >/dev/null
   pushd "${S}" >/dev/null
   sed -i 's/\("node":\s"\).*",/\1x.x",/' package.json
   popd >/dev/null
}

src_compile() {
    #the grafana make script is not safe for parallel execution
    emake -j1 || die "emake failed"
}

src_install() {
    debug-print-function ${FUNCNAME} "$@"

    pushd "${SRC_DIR}/bin" >/dev/null
    dobin grafana-cli grafana-server
    popd >/dev/null

    insinto /usr/share/${PN}/public
    doins -r public_gen/*
    insinto /usr/share/${PN}/conf
    doins conf/defaults.ini
    insinto /etc/${PN}
    doins conf/grafana.ini conf/ldap.toml

    newconfd "${FILESDIR}"/grafana.confd grafana
    newinitd "${FILESDIR}"/grafana.initd grafana
}

pkg_setup() {
    enewgroup ${PN}
    enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
}
