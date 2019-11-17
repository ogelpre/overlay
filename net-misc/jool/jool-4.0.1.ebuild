EAPI=7

inherit linux-mod autotools bash-completion-r1

DESCRIPTION="Jool is an Open Source SIIT and NAT64 for Linux."
HOMEPAGE="https://nicmx.github.io/Jool/en/"
SRC_URI="https://github.com/NICMx/Jool/releases/download/v${PV}/${PN}_4.0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="daemon iptables tools "

DEPEND="sys-apps/ethtool dev-libs/libnl"
RDEPEND="${DEPEND}"

BUILD_TARGETS="modules"

MODULE_NAMES="jool(net:${S}/src/mod:${S}/src/mod/nat64) jool_siit(net:${S}/src/mod:${S}/src/mod/siit)"

#BUILD_PARAMS="-j1"

PATCHES=("${FILESDIR}/${P}-Makefile.patch")

src_configure() {
    econf --with-bash-completion-dir=no
}

src_compile() {
    linux-mod_src_compile

    if use daemon; then
        cd "${S}/src/usr/joold"
        einfo "$(pwd)"
        emake || die "emake failed"
    fi

    if use iptables; then
        cd "${S}/src/usr/iptables"
        einfo "$(pwd)"
        emake || die "emake failed"
    fi

    if use tools; then
        cd "${S}/src/usr/nat64"
        einfo "$(pwd)"
        emake || die "emake failed"

        cd "${S}/src/usr/siit"
        einfo "$(pwd)"
        emake || die "emake failed"
    fi
}

src_install() {
    linux-mod_src_install

    dodoc doc/*

    if use daemon; then
        cd "${S}/src/usr/joold"
        emake DESTDIR="${D}" install || die "emake install failed"
    fi

    if use iptables; then
        cd "${S}/src/usr/iptables"
        emake DESTDIR="${D}" install || die "emake install failed"
    fi

    if use tools; then
        cd "${S}/src/usr/nat64"
        doman *.8
        newbashcomp jool.bash jool
        emake DESTDIR="${D}" install || die "emake install failed"

        cd "${S}/src/usr/siit"
        doman *.8
        newbashcomp jool_siit.bash jool_siit
        emake DESTDIR="${D}" install || die "emake install failed"
    fi
}
