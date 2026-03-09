EAPI=8

DESCRIPTION="Dinit scripts"
HOMEPAGE="https://gitea.artixlinux.org/artix/dinit-rc"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="sys-apps/dinit sys-apps/dbus"

SRC_URI="https://gitea.artixlinux.org/packages/dbus-dinit/archive/${PVR//r/}.tar.gz"
S="${WORKDIR}/${PN}"

src_configure() {
	sed -i 's/artix/gentoo/g' "${S}"/dbus-pre
	sed -i 's/artix/gentoo/g' "${S}"/dbus-pre.script
}

src_install() {
	insinto /usr/lib/dinit.d/
	doins dbus
	doins dbus-pre
	exeinto /usr/lib/dinit/
	newexe dbus.script dbus
	exeinto /usr/lib/dinit/pre/
	newexe dbus-pre.script dbus
	insinto /etc/dinit.d/user/
	newins dbus.user dbus
	exeinto /usr/lib/dinit/user/
	newexe dbus.user.script dbus
	dosym -r /etc/dinit.d/user/dbus /usr/lib/dinit.d/user/boot.d/dbus
}
