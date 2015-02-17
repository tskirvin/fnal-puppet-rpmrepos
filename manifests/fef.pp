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
#   class { 'rpmrepos::fef': }
#
class rpmrepos::fef (
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
      baseurl  => $url_arch,
      descr    => 'fef managed rpms',
      enabled  => $enabled,
      gpgcheck => false,
      proxy    => $proxy,
    }
    yumrepo { 'fef-managed-noarch':
      baseurl  => $url_noarch,
      descr    => 'fef managed noarch rpms',
      enabled  => $enabled,
      gpgcheck => false,
      proxy    => $proxy,
    }
  } else {
    notice ("${::operatingsystem}: not compatible with FEF rpm repos")
  }
}
