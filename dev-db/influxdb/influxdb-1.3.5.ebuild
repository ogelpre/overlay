# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

# Based on ebuild by Jonathan Vasquez <jvasquez1011@gmail.com>

EAPI=6

GITHUB_USER="influxdata"
GITHUB_REPO="${PN}"

EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}/..."

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        EGIT_COMMIT="e47cf1f2e83a02443d7115c54f838be8ee959644"
        ARCHIVE_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64"
        inherit golang-vcs-snapshot
fi

inherit golang-build user

DESCRIPTION="time-series data storage"
HOMEPAGE="https://www.influxdata.com"
SRC_URI="${ARCHIVE_URI}"

RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"


IUSE=""
DEPEND=">=dev-lang/go-1.8.3
        dev-go/gdm"
RDEPEND="!<dev-lang/go-1.8.3"

SRC_DIR="${WORKDIR}/${P}/src/${EGO_PN%...}"

src_prepare() {
    #dirty hack: load all needed go pacakges via gdm
    cd "${SRC_DIR}"
    export GOPATH="${WORKDIR}/${P}"
    $(go env GOROOT)/bin/gdm restore
    sed -i '/# reporting-disabled = false/a reporting-disabled = true' "${SRC_DIR}/etc/config.sample.toml"

    default
}

src_install() {
    debug-print-function ${FUNCNAME} "$@"

    ego_pn_check
    set -- env GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" \
        go install -v -work -x ${EGO_BUILD_FLAGS} \
        -ldflags "-X main.version=${PV} -X main.branch=$(git rev-parse --abbrev-ref HEAD) -X main.commit=${EGIT_COMMIT}" \
        "${EGO_PN}"

    echo "$@"
    "$@" || die

    pushd "${WORKDIR}/${P}/bin" >/dev/null
    dobin influx  influxd  influx_inspect  influx_stress  influx_tsm
    popd >/dev/null

    confdir="/etc/influxdb"
    dodir "${confdir}"
    insinto "${confdir}"
    newins "${SRC_DIR}/etc/config.sample.toml" "influxdb.conf"

    newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
    newinitd "${FILESDIR}/${PN}.init.d" "${PN}"

}


pkg_setup() {
     enewgroup ${PN}
     enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
}


