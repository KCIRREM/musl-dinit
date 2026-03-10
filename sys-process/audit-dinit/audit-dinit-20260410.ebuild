# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service scripts for dhcpcd"
HOMEPAGE="https://artixlinux.org"

EGIT_REPO_URI="https://gitea.artixlinux.org/packages/audit-dinit.git"
EGIT_COMMIT="4c7c5a028b73dd7a5cc2c2de860b5ba29333f071"

inherit git-r3

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	sys-process/audit
	sys-apps/dinit
"

src_install() {
	insinto /usr/lib/dinit.d/
	doins auditd
	doins auditdctl
	exeinto /usr/lib/dinit
	newexe auditctl.script auditctl
	insinto /etc/dinit.d/config/
	doins auditctl.conf
}
