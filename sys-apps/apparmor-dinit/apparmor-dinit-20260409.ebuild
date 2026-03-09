# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service script for apparmor"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
RDEPEND="
	sys-apps/apparmor
	sys-apps/dinit
"

S="${WORKDIR}"
src_install() {
	insinto /usr/lib/dinit.d
	doins "${FILESDIR}"/apparmor
	exeinto /usr/lib/dinit
	newexe "${FILESDIR}"/apparmor.script apparmor
}
