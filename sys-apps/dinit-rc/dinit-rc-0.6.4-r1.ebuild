EAPI=8

DESCRIPTION="Dinit scripts"
HOMEPAGE="https://gitea.artixlinux.org/artix/dinit-rc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

IUSE="mdevd"

RDEPEND="sys-apps/artix-cgroups"

SRC_URI="https://gitea.artixlinux.org/artix/dinit-rc/archive/${PV}.tar.gz"
S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/fix-paths-and-root-ro.patch
)

src_prepare() {
    default

    sed -i '/install -Dm644 misc\/50-default.conf \$(DESTDIR)\$(LIBDIR)\/sysctl.d\/50-default.conf/d' "${S}"/Makefile
    if use mdevd; then
	eapply "${FILESDIR}"/mdevd.patch
	cp "${FILESDIR}"/mdevd* "${S}"/services
    fi
}
