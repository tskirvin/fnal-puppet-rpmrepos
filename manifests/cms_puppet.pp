# rpmrepos::cms_puppet
#
#   Enable the puppet repositories mirrored by the CMS install servers (using
#   yumrepo) and import relevant GPG keys.
#
# == Parameters
#
#   baseurl   http://cms-install.fnal.gov/cobbler/repo_mirror
#   enabled   Gets passed to yumrepo.  Default: true
#   itb       If 'true', points at the CMS ITB OSG mirror rather than the
#             default (the non-ITB mirror updates more often).  Default: false
#   priority  What yum priority should this repo get?  Lower is "better".
#             Default: 50
#   proxy     Gets passed to yumrepo.  Default: 'absent'
#
# == Requirements
#
#   You must be running a RHEL variant - CentOS, RHEL, Scientific, SLF, Oracle,
#   Ascendos, etc
#
#   puppetlabs-stdlib
#
# == Usage
#
#   class { 'rpmrepos::cms_puppet': }
#
class rpmrepos::cms_puppet (
  $baseurl  = 'http://cms-install.fnal.gov/cobbler/repo_mirror',
  $enabled  = true,
  $itb      = false,
  $priority = '50',
  $proxy    = 'absent'
) {
  validate_bool   ($enabled, $itb)
  validate_string ($baseurl, $proxy, $priority)

  if $itb { $extra = 'itb' }
  else    { $extra = '' }
  $gpgkey  = '/etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs'

  if $::osfamily == 'RedHat' {
    yumrepo { 'puppet':
      baseurl  => "${baseurl}/puppet-el${::lsbmajdistrelease}-${::architecture}${extra}",
      descr    => "Puppet RPMs for EL ${::lsbmajdistrelease} - ${::architecture}",
      enabled  => $enabled,
      gpgcheck => true,
      gpgkey   => "file://${gpgkey}",
      priority => $priority,
      proxy    => $proxy
    }

    yumrepo { 'puppet-deps':
      baseurl  => "${baseurl}/puppet-deps-el${::lsbmajdistrelease}-${::architecture}${extra}",
      descr    => "Puppet Dependency RPMs for EL ${::lsbmajdistrelease} - ${::architecture}",
      enabled  => $enabled,
      gpgcheck => true,
      gpgkey   => "file://${gpgkey}",
      priority => $priority,
      proxy    => $proxy,
    }

    file { $gpgkey:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/rpmrepos/RPM-GPG-KEY-puppetlabs',
    }

    rpmrepos::rpm_gpg_key { 'puppetlabs': path => "file://${gpgkey}" }
  } else {
    notice ("${::operatingsystem}: not compatible with puppet repo")
  }
}
