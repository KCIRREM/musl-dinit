# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service script for syslog-ng"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
RDEPEND="
	app-admin/syslog-ng
	sys-apps/dinit
"

S="${WORKDIR}"
src_install() {
	insinto /etc/dinit.d
	doins "${FILESDIR}"/syslog-ng
}
