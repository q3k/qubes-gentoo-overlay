# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Essential guest Xen tools for QubesOS"
HOMEPAGE="https://www.qubes-os.org/"
SRC_URI="http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='xml,threads'

DEPEND="amd64? (
	sys-devel/bin86
	sys-devel/dev86
	sys-power/iasl )
	media-libs/libsdl"
RDEPEND="${DEPEND}
	!!app-emulation/xen-tools"

inherit python-single-r1

S="${WORKDIR}/xen-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${PV}/${P}-001-xen-initscript.patch" \
	       "${FILESDIR}/${PV}/${P}-004-xen-dumpdir.patch" \
	       "${FILESDIR}/${PV}/${P}-005-xen-net-disable-iptables-on-bridge.patch" \
	       "${FILESDIR}/${PV}/${P}-010-xen-no-werror.patch" \
	       "${FILESDIR}/${PV}/${P}-018-localgcc45fix.patch" \
	       "${FILESDIR}/${PV}/${P}-020-localgcc451fix.patch" \
	       "${FILESDIR}/${PV}/${P}-026-localgcc46fix.patch" \
	       "${FILESDIR}/${PV}/${P}-028-pygrubfix.patch" \
	       "${FILESDIR}/${PV}/${P}-030-gdbsx-glibc2.17.patch" \
	       "${FILESDIR}/${PV}/${P}-031-xen-shared-loop-losetup.patch" \
           "${FILESDIR}/${PV}/${P}-101-xen-configure-xend.patch" \
           "${FILESDIR}/${PV}/${P}-102-xen-acpi-override-query.patch" \
           "${FILESDIR}/${PV}/${P}-102-xen-no-downloads.patch" \
           "${FILESDIR}/${PV}/${P}-103-xen-dont-install-outdated-latex-documentation.patch" \
           "${FILESDIR}/${PV}/${P}-104-xen-tools-canonicalize-python-location.patch" \
           "${FILESDIR}/${PV}/${P}-111-xen-hotplug-external-store.patch" \
           "${FILESDIR}/${PV}/${P}-500-xen-tools-qubes-vm.patch"
}

src_compile() {
	local XEN_VENDORVERSION="-${PR}"
	export XEN_VENDORVERSION
	local OCAML_TOOLS=n
	export OCAML_TOOLS
	python_export PYTHON

	emake -C tools
}

src_install() {
	local XEN_VENDORVERSION="-${PR}"
	export XEN_VENDORVERSION
	local OCAML_TOOLS=n
	export OCAML_TOOLS
	python_export PYTHON

    # Let the build system compile installed Python modules.
    local PYTHONDONTWRITEBYTECODE
    export PYTHONDONTWRITEBYTECODE

    emake DESTDIR="${ED}" DOCDIR="/usr/share/doc/${PF}" \
        XEN_PYTHON_NATIVE_INSTALL=y install-tools

    # Fix the remaining Python shebangs.
    python_fix_shebang "${D}"

    # Remove RedHat-specific stuff
    rm -rf "${D}"tmp || die

	# Remove stuff not used in QUbes
	rm -rf "${D}"usr/share
	rm -rf "${D}"etc/hotplug
	rm -rf "${D}"etc/init.d
	rm -rf "${D}"etc/default
	rm -f "${D}"usr/sbin/xenstored
	rm -rf "${D}"var/run
	rm -rf "${D}"var/lock
	rm -rf "${D}"var/lib/xenstored
}
