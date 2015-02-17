# rpmrepos::fef
#
#   Enable the FEF yum repositories (using yumrepo).
#
# == Parameters
#
#   baseurl   http://rexadmin1.fnal.gov/yum-managed/
#   enabled   Gets passed to yumrepo.  Default: 1
#   priority  What yum priority should this repo get?  Lower is "better".
#             Default: 60
#   proxy     Gets passed to yumrepo.  Default: 'absent'
#
# == Requirements
#
#   You must be running a RHEL variant - CentOS, RHEL, Scientific, SLF, Oracle,
#   Ascendos, etc
#
#   puppetlabs-stdlib
#
# == Usage Usage:
#
#   class { 'rpmrepos::fef': }
#
class rpmrepos::fef (
  $baseurl  = 'http://rexadmin1.fnal.gov/yum-managed',
  $enabled  = 1,
  $priority = '60',
  $proxy    = 'absent'
) {
  validate_string ($enabled, $baseurl, $proxy, $priority)

  $url_noarch = "${baseurl}/RPMS/noarch/\$releasever/"
  $url_arch   = "${baseurl}/RPMS/\$basearch/\$releasever/"

  if $::osfamily == 'RedHat' {
    yumrepo { 'fef-managed':
      baseurl  => $url_arch,
      descr    => 'fef managed rpms',
      enabled  => $enabled,
      gpgcheck => '0',
      priority => $priority,
      proxy    => $proxy,
    }
    yumrepo { 'fef-managed-noarch':
      baseurl  => $url_noarch,
      descr    => 'fef managed noarch rpms',
      enabled  => $enabled,
      gpgcheck => '0',
      priority => $priority,
      proxy    => $proxy,
    }
  } else {
    notice ("${::operatingsystem}: not compatible with FEF rpm repos")
  }
}
