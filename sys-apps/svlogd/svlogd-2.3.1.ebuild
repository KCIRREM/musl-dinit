# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Standalone svlogd utility stripped from the runit codebase"
HOMEPAGE="http://smarden.org"
SRC_URI="https://smarden.org/runit/runit-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

S="${WORKDIR}/admin/runit-${PV}/src"

src_prepare() {
	default
	# Don't force static linking
	sed -i -e 's:-static: :' Makefile || die
}

src_configure() {
	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	sed -i -e "s:ar cr:$(tc-getAR) cr:" print-ar.sh || die
	sed -i -e "s:ranlib :$(tc-getRANLIB) :" print-ar.sh || die
}

src_compile() {
	# Build only svlogd and its dependencies
	emake svlogd
}

src_install() {
	dobin svlogd
	doman ../man/svlogd.8
}
