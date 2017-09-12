# Copyright 2015-2016 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GITHUB_USER="sparrc"
GITHUB_REPO="${PN}"

EGO_PN="github.com/${GITHUB_USER}/${GITHUB_REPO}/..."

if [[ ${PV} = *9999* ]]; then
        inherit golang-vcs
else
        EGIT_COMMIT="63f5bac169f44cedc650d5581d048c6ff3bcfcb4"
        ARCHIVE_URI="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64"
        inherit golang-vcs-snapshot
fi

inherit golang-build

DESCRIPTION="go dependency manager"
HOMEPAGE="https://github.com/sparrc/gdm"
SRC_URI="${ARCHIVE_URI}"

RESTRICT="mirror"
LICENSE="Unlicense"
SLOT="0"

IUSE=""
DEPEND=">=dev-lang/go-1.7.4
        dev-go/go-tools"
RDEPEND="!<dev-lang/go-1.7.4"

src_install() {
    exeinto "$(go env GOROOT)/bin"
    doexe "${PN}"
}
