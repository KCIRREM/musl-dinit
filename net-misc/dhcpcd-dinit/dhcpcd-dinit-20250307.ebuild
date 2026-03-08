# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dinit service scripts for dhcpcd"
HOMEPAGE="https://artixlinux.org"

EGIT_REPO_URI="https://gitea.artixlinux.org/packages/dhcpcd-dinit.git"
EGIT_COMMIT="d3bee8999298ba60596a5c775a1eadb7e8eb34f0"

inherit git-r3

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	net-misc/dhcpcd
	sys-apps/dinit
"

CONFLICT="init-dhcpcd"

src_install() {
	insinto /usr/lib/dinit.d
	doins dhcpcd
}
