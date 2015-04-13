# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Common Linux files for Qubes VM."
HOMEPAGE="https://qubes-os.org/"
EGIT_REPO_URI="https://github.com/QubesOS/qubes-linux-utils.git"
EGIT_REPO_COMMIT="v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-emulation/qubes-libvchan-xen"
RDEPEND="${DEPEND}"

inherit git-r3 systemd

src_prepare() {
	epatch "${FILESDIR}/${PV}/${P}-00-configure-systemd-unitdir.patch"
}

src_compile() {
	emake all
}

src_install() {
	emake DESTDIR="${D}" UNITDIR="$(systemd_get_unitdir)" install
	mkdir -p "${D}"lib/udev
	mv "${D}"etc/udev/rules.d "${D}"lib/udev/
}
