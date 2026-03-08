# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service scripts for chrony"
HOMEPAGE="https://artixlinux.org"
SRC_URI="https://gitea.artixlinux.org/packages/chrony-dinit/archive/${PVR//r/}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/chrony-dinit"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	net-misc/chrony
	sys-apps/dinit
"

src_install() {
	insinto /etc/dinit.d
	doins chronyd
	doins chrony

	exeinto /usr/lib/dinit
	doexe chronyd.script
}
