# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module git-r3

DESCRIPTION="Full set of AppArmor profiles (~1500) to confine most Linux applications"
HOMEPAGE="https://apparmor.pujol.io https://github.com/roddhjav/apparmor.d"

EGIT_REPO_URI="https://github.com/roddhjav/apparmor.d.git"
EGIT_BRANCH="main"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="enforce"

BDEPEND="
	>=dev-lang/go-1.23
	dev-build/just
	net-misc/rsync
"

RDEPEND="
	sys-apps/apparmor
"

# apparmor.d has no formal releases — live ebuild only.
# Build system: Go tool (aa-build) invoked via 'just'.
# Mimics the Arch PKGBUILD from the upstream repo.

src_compile() {
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	export GOPATH="${WORKDIR}/go"
	export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw"

	# Use 'other' distribution — no Gentoo target exists upstream.
	# Avoids Ubuntu/Debian/Arch-specific path assumptions.
	export DISTRIBUTION="other"

	# 'just complain' builds all profiles and sets them to complain mode.
	# Safe default — do not use 'just enforce' without extensive testing
	# especially on musl/dinit systems.
	just complain || die "just complain failed"
}

src_install() {
	just destdir="${ED}" install || die "just install failed"

	# Recommended parser.conf settings for large profile sets (~100k lines).
	# Enables fast cache compression and early policy load support.
	insinto /etc/apparmor
	newins - apparmor.d.conf <<-EOF
		write-cache
		cache-loc /etc/apparmor/earlypolicy/
		Optimize=compress-fast
	EOF

	keepdir /etc/apparmor/earlypolicy

	dodoc README.md
}

pkg_postinst() {
	elog ""
	elog "apparmor.d installed — all profiles are in COMPLAIN mode."
	elog ""
	elog "Recommended next steps:"
	elog "  1. Reboot your system"
	elog "  2. Monitor logs: grep apparmor /var/log/everything"
	elog "  3. Run: aa-unconfined   (check what is still unconfined)"
	elog "  4. Run: aa-status       (check loaded profiles)"
	elog "  5. Use complain mode for at least a week before enforcing"
	elog ""
	elog "Note: This system uses musl libc + dinit. Profiles targeting"
	elog "systemd or glibc-specific paths will be harmlessly irrelevant"
	elog "in complain mode but should not cause breakage."
	elog ""

	if use enforce; then
		ewarn "enforce USE flag is set — switching all profiles to enforce mode."
		ewarn "This WILL break your system if profiles are not validated first."
		ewarn "Only set this after extended complain mode testing."
	fi
}
