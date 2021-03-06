# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tool and library to extract CAB files from InstallShield installers"
HOMEPAGE="https://github.com/twogood/unshield"
SRC_URI="https://github.com/twogood/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="static-libs"

RDEPEND="
	dev-libs/openssl:=
	sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	local PATCHES=( "${FILESDIR}/${PN}-1.0-bootstrap.patch" )
	default
	"${S}/bootstrap" || die "bootstrap script failed"
	eautoreconf
}

src_configure() {
	local myeconf=(
		$(use_enable static-libs static)
		--with-ssl
	)
	econf "${myeconf[@]}"
}

pkg_preinst() {
	find "${D}" -name '*.la' -exec rm -f {} +
}
