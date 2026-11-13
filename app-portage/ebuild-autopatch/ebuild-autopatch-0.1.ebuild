# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Maintain a local overlay of patched upstream ebuilds"
HOMEPAGE=""
S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+default-patchset +postsync"

RDEPEND="
	acct-group/portage
	acct-user/portage
	>=app-shells/bash-4.2
	net-misc/rsync
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/grep
	sys-apps/portage
	sys-apps/util-linux
	sys-devel/patch
"

src_install() {
	dosbin "${FILESDIR}/${PN}"

	insinto /etc/portage/repos.conf
	newins - "${PN}.conf" <<-EOF
		[${PN}]
		location = ${EPREFIX}/var/db/repos/${PN}
		priority = 500
		auto-sync = no
	EOF

	insinto "/var/db/repos/${PN}/profiles"
	newins - repo_name <<< "${PN}"

	keepdir /etc/portage/ebuild-patches
	keepdir "/var/db/repos/${PN}/metadata"
	keepdir "/var/lib/${PN}"

	fowners -R portage:portage "/var/db/repos/${PN}" "/var/lib/${PN}"

	if use default-patchset && [[ -d ${FILESDIR}/patches ]]; then
		insinto "/usr/share/${PN}/patches"
		doins -r "${FILESDIR}/patches/."
	fi

	if use postsync; then
		exeinto /etc/portage/postsync.d
		newexe - "50-${PN}" <<-EOF
			#!/bin/sh
			exec "${EPREFIX}/usr/sbin/${PN}"
		EOF
	fi
}

pkg_postinst() {
	if [[ -z ${ROOT} ]]; then
		ebegin "Updating ::${PN} overlay"
		if env -i PATH="${PATH}" "${EPREFIX}/usr/sbin/${PN}"; then
			eend 0
		else
			eend 1
			ewarn "One or more patches failed to apply; check the output above."
		fi
	fi
}

pkg_prerm() {
	# REPLACING_VERSIONS is non-empty during upgrades/reinstalls, and empty on full unmerge
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		ebegin "Cleaning up dynamically generated ::${PN} ebuilds and state"
		if [[ -d ${EROOT}/var/db/repos/${PN} ]]; then
			find "${EROOT}/var/db/repos/${PN}" -mindepth 1 \
				! -path "${EROOT}/var/db/repos/${PN}/profiles" \
				! -path "${EROOT}/var/db/repos/${PN}/profiles/repo_name" \
				! -path "${EROOT}/var/db/repos/${PN}/metadata" \
				! -name ".keep*" \
				-delete 2>/dev/null
		fi
		if [[ -d ${EROOT}/var/lib/${PN} ]]; then
			find "${EROOT}/var/lib/${PN}" -mindepth 1 \
				! -name ".keep*" \
				-delete 2>/dev/null
		fi
		rm -f "${EROOT}/run/lock/${PN}.lock"
		eend 0
	fi
}
