# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service scripts for iwd"
HOMEPAGE="https://artixlinux.org"

EGIT_REPO_URI="https://gitea.artixlinux.org/packages/iwd-dinit.git"
EGIT_COMMIT="76e08af824bd69865d43f84073b040570281b39f"

inherit git-r3

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	net-wireless/iwd
	sys-apps/dinit
"

BDEPEND="sys-apps/dinit"

CONFLICT="init-iwd"

src_install() {
	insinto /usr/lib/dinit.d
	doins iwd
	doins ead
}
