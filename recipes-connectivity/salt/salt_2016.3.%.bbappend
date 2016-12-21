LIC_FILES_CHKSUM = "file://LICENSE;md5=fb92f464675f6b5df90f540d60237915"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI = "${NILRT_GIT}/salt.git;protocol=git;branch=nilrt/cardassia/develop \
           file://set_python_location_hashbang.patch \
           file://minion \
           file://salt-minion \
           file://salt-common.bash_completion \
           file://salt-common.logrotate \
           file://salt-api \
           file://salt-master \
           file://master \
           file://salt-syndic \
           file://cloud \
           file://roster \
           file://run-ptest \
"

SRCREV = "${AUTOREV}"
PV = "2016.3+git${SRCPV}"

S="${WORKDIR}/git"

PACKAGECONFIG = "tcp"

# make sure python-avahi RPROVIDE-ed by avahi-ui is built before salt
# because salt-minion RDEPENDS on it to avoid a build race
DEPENDS += "avahi-ui"

RDEPENDS_${PN}-minion += "python-avahi python-pyinotify python-pyroute2 python-modules"
RDEPENDS_${PN}-common_remove = "python-dateutil python-requests"
RDEPENDS_${PN}-tests += "python-pyzmq python-six python-image"
RDEPENDS_${PN}-ptest += "salt-tests"
# Note that the salt test suite (salt-tests) require python-pyzmq to run
# properly even though we run them in tcp mode

inherit update-rc.d ptest
INITSCRIPT_PARAMS_${PN}-minion = "defaults 25 25"

do_install_ptest_append() {
    install -m 0755 ${WORKDIR}/run-ptest ${D}${PTEST_PATH}
}
