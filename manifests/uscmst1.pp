# rpmrepos::uscmst1
#
#   Enable the USCMS-T1 yum repository (using yumrepo).
#
#   TODO: we are not yet enabling the signing key as a requirements, but
#   we do have one.
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
#   class { 'rpmrepos::uscmst1': }
#
class rpmrepos::uscmst1 (
  $baseurl  = 'http://cms-install.fnal.gov/cobbler/repo_mirror',
  $enabled  = '1',
  $priority = '90',
  $proxy    = 'absent'
) {
  validate_bool   ($enabled)
  validate_string ($baseurl, $proxy, $priority)

  $url = "${baseurl}/uscmst1-el${::lsbmajdistrelease}-${::architecture}"
  $gpgkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-uscmst1'
  if $::osfamily == 'RedHat' {
    yumrepo { 'uscmst1':
      baseurl  => $url,
      descr    => "USCMS-T1 RPMs for SL ${::lsbmajdistrelease} - ${::architecture}",
      enabled  => $enabled,
      gpgcheck => '0',
      proxy    => $proxy,
    }

    file { $gpgkey:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/rpmrepos/RPM-GPG-KEY-uscmst1'
    }

    rpmrepos::rpm_gpg_key { 'uscmst1': path => $gpgkey }
  } else {
    notice ("${::operatingsystem}: not compatible with USCMS-T1 rpm repo")
  }
}
