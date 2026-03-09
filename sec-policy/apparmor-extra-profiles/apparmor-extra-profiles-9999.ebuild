# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Full set of AppArmor profiles (~1500) to confine most Linux applications"
HOMEPAGE="https://apparmor.pujol.io https://github.com/roddhjav/apparmor.d"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/roddhjav/apparmor.d.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://github.com/roddhjav/apparmor.d/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="enforce"

BDEPEND="
	>=dev-lang/go-1.23
	dev-build/just
"

RDEPEND="
	sys-apps/apparmor
"

# apparmor.d uses a custom Go-based build tool called 'aa-build'
# and 'just' as the task runner.

src_configure() {
	# Set the target distribution to 'other' for non-Ubuntu/Debian/Arch systems.
	# This avoids distro-specific assumptions in profiles.
	export DISTRIBUTION="other"
}

src_compile() {
	# Build the aa-build Go tool first
	ego build -o aa-build ./cmd/aa-build

	# Run the prebuild step to process profiles for our distribution
	./aa-build build --distribution "${DISTRIBUTION}" || die "aa-build failed"
}

src_install() {
	# Install processed profiles from the build output directory
	insinto /etc/apparmor.d
	doins -r .build/apparmor.d/.

	# Install the aa-build tool for later use (e.g. regenerating profiles)
	dobin aa-build

	# Install parser.conf snippet for fast caching (recommended by upstream)
	insinto /etc/apparmor
	newins - apparmor.d.conf <<-EOF
		write-cache
		cache-loc /etc/apparmor/earlypolicy/
		Optimize=compress-fast
	EOF

	# Create early policy cache directory
	keepdir /etc/apparmor/earlypolicy

	# Install docs
	dodoc README.md
}

pkg_postinst() {
	elog ""
	elog "apparmor.d has been installed with all profiles in COMPLAIN mode."
	elog ""
	elog "Important steps:"
	elog "  1. Reboot your system"
	elog "  2. Monitor AppArmor logs: grep apparmor /var/log/everything"
	elog "  3. Use complain mode for at least a week before enforcing"
	elog ""

	if use enforce; then
		ewarn "You have enabled 'enforce' USE flag."
		ewarn "This will put ALL profiles into enforce mode."
		ewarn "This may break your system if profiles are not tuned for"
		ewarn "your musl/dinit Gentoo setup. Proceed with caution."
	fi

	elog "To check unconfined processes: aa-unconfined"
	elog "To check profile status:       aa-status"
	elog ""
	elog "Note: This system uses musl libc and dinit. Some profiles"
	elog "targeting glibc paths or systemd units will be harmlessly"
	elog "irrelevant but should not cause breakage in complain mode."
}
