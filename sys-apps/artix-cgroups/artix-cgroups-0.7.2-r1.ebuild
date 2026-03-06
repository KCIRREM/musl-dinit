EAPI=8

DESCRIPTION="Artix cgroups scripts for non-systemd systems"
HOMEPAGE="https://gitea.artixlinux.org/artix/dinit-rc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

SRC_URI="https://gitea.artixlinux.org/artix/artix-cgroups/archive/${PV}.tar.gz"
S="${WORKDIR}/${PN}"

src_prepare() {
    default

    # Replace Artix config path
    sed -i 's|PREFIX = /usr/local|PREFIX = /usr|' Makefile
    sed -i 's|artix|gentoo|g' Makefile
    sed -i 's|artix|gentoo|g' src/lib/util-cg.sh
}
