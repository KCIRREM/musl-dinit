EAPI=8

DESCRIPTION="service manager and init system"
HOMEPAGE=("https://davmac.org/projects/dinit/"
	"https://github.com/davmac314/dinit")
SRC_URI="https://github.com/davmac314/${PN}/releases/download/v${PV}/${P}.tar.xz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="init +cgroups utmpx +initgroups +capabilities +ioprio +oom-adj"
KEYWORDS="~amd64"
RESTRICT="primaryuri"
DOCS=(NEWS README.md TODO doc/COMPARISON doc/DESIGN doc/SECURITY doc/getting_started.md
	doc/linux/DINIT-AS-INIT.md)


DEPEND="
        capabilities? ( sys-libs/libcap )
"

RDEPEND="
  init? ( sys-apps/dinit-rc )
  !sys-apps/openrc[sysvinit,sysv-utils,s6]
  !sys-apps/s6-linux-init[sysv-utils]
  !sys-apps/systemd
  !sys-apps/sysvinit
"


src_configure() {
	econf \
		$(use_enable init shutdown) \
		$(use_enable utmpx) \
		$(use_enable initgroups) \
		$(use_enable cgroups) \
		$(use_enable capabilities) \
		$(use_enable ioprio) \
		$(use_enable oom-adj)
}
src_install() {
	default
	if use init; then
		dosbin src/dinit
		dosym -s -r /sbin/dinit /sbin/init
	fi
}
