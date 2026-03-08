# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service scripts for metalog"
HOMEPAGE="https://artixlinux.org"

EGIT_REPO_URI="https://gitea.artixlinux.org/packages/metalog-dinit.git"
EGIT_COMMIT="385f7876b7d2d7134e6158fc7964e4ec65e3cf1e"

inherit git-r3

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	app-admin/syslog-ng
	sys-apps/dinit
"

CONFLICT="init-metalog"

src_install() {
	insinto /etc/dinit.d
	doins metalog
}
