# rpmrepos::fef
#
#   Enable the FEF yum repositories (using yumrepo).
#
# == Parameters
#
#   baseurl   http://rexadmin1.fnal.gov/yum-managed/
#   enabled   Gets passed to yumrepo.  Default: true
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
#   class { 'rpmrepos::uscmst1': }
#
class rpmrepos::uscmst1 (
  $baseurl  = 'http://rexadmin1.fnal.gov/yum-managed/',
  $enabled  = true,
  $priority = '60',
  $proxy    = 'absent'
) {
  validate_bool   ($enabled)
  validate_string ($baseurl, $proxy, $priority)

  $url_noarch = "${baseurl}/RPMS/noarch/\$releasevar"
  $url_arch   = "${baseurl}/RPMS/\$basearch/\$releasevar"

  if $::osfamily == 'RedHat' {
    yumrepo { 'fef-managed':
      descr    => 'fef managed rpms',
      enabled  => $enabled,
      gpgcheck => false,
      proxy    => $proxy,
      url      => $url_arch,
    }
    yumrepo { 'fef-managed-noarch':
      descr    => 'fef managed noarch rpms',
      enabled  => $enabled,
      gpgcheck => false,
      proxy    => $proxy,
      url      => $url_noarch,
    }
  } else {
    notice ("${::operatingsystem}: not compatible with FEF rpm repos")
  }
}
