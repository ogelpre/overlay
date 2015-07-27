# Copyright 2015 Benedikt Neuffer <ogelpre@itfriend.de>
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="ramond is a scriptable IPv6 Router Advertisement Monitoring Daemon"
HOMEPAGE="http://ramond.sourceforge.net/"

SRC_URI="mirror://sourceforge/project/${PN}/${PN}/_${PV}/${P}.tar.bz2"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="
	dev-libs/apr
	net-libs/libpcap
	dev-libs/libxml2
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch_user

	epatch "${FILESDIR}/README-0.5.patch"

	EXAMPLESDIR="${S}/examples"
	mkdir -p "${EXAMPLESDIR}"
	mv demo.pl ramond.conf.dtd ramond.conf.example "${EXAMPLESDIR}"/

	sed "s|{{{P}}}|${P}|g" "${FILESDIR}/ramond-0.5.conf.man5" > "${WORKDIR}/ramond.conf.5"
	sed "s|{{{PORTDIR}}}|${PORTDIR}|g" "${FILESDIR}/ramond-0.5.man8" > "${WORKDIR}/ramond.8"
}

src_install() {
	dosbin "${PN}"

	newinitd "${FILESDIR}/ramond-0.5.initd" ramond

	dodoc CHANGELOG README THANKS examples/*

	doman "${WORKDIR}/ramond.8" "${WORKDIR}/ramond.conf.5"
}
