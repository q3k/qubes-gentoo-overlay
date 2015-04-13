# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="QubesOS libvchan cross-domain communication library"
HOMEPAGE="http://www.qubes-os.org"
EGIT_REPO_URI="https://github.com/QubesOS/qubes-core-vchan-xen.git"
EGIT_COMMIT="v${PV}"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="app-emulation/qubes-vm-xen"
RDEPEND="${DEPEND}"

inherit git-r3

src_prepare() {
	epatch "${FILESDIR}/${PV}/${P}-00-add-soname.patch"
}

src_compile() {
	( cd u2mfn; emake )
	( cd vchan; emake -f Makefile.linux )
}

src_install() {
	install -D -m 0644 vchan/libvchan.h "${D}"usr/include/libvchan.h
	install -D -m 0644 u2mfn/u2mfnlib.h "${D}"usr/include/u2mfnlib.h
	install -D -m 0644 u2mfn/u2mfn-kernel.h "${D}"usr/include/u2mfn-kernel.h

	install -D vchan/libvchan.so "${D}"usr/lib/libvchan.so.0
	install -D u2mfn/libu2mfn.so "${D}"usr/lib/libu2mfn.so.0
}
