# rpmrepos::dcso
#
#   Enable the DCSO yum repository (using yumrepo).
#
# == Parameters
#
#   baseurl   http://cms-install.fnal.gov/cobbler/repo_mirror
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
#   class { 'rpmrepos::dcso': }
#
class rpmrepos::dcso (
  $baseurl  = 'http://cms-install.fnal.gov/cobbler/repo_mirror',
  $enabled  = '1',
  $priority = '90',
  $proxy    = 'absent'
) {
  validate_string ($baseurl, $enabled, $proxy, $priority)

  $url = "${baseurl}/dcso-el${::lsbmajdistrelease}-${::architecture}"
  $gpgkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-dcso'
  if $::osfamily == 'RedHat' {
    yumrepo { 'dcso':
      baseurl  => $url,
      descr    => "DCSO RPMs for EL ${::lsbmajdistrelease} - ${::architecture}",
      enabled  => $enabled,
      gpgcheck => '1',
      proxy    => $proxy,
    }

    file { $gpgkey:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/rpmrepos/RPM-GPG-KEY-dcso'
    }

    rpmrepos::rpm_gpg_key { 'dcso': path => $gpgkey }
  } else {
    notice ("${::operatingsystem}: not compatible with DCSO rpm repo")
  }
}
