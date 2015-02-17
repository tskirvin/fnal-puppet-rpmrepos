# rpmrepos::cms_osg
#
#   Enable the OSG repositories mirrored by the CMS install servers (using
#   yumrepo) and import relevant GPG keys.
#
# == Parameters
#
#   baseurl   http://cms-install.fnal.gov/cobbler/repo_mirror
#   enabled   Gets passed to yumrepo.  Default: 1
#   itb       If 'true', points at the CMS ITB OSG mirror rather than the
#             default (the non-ITB mirror updates more often).  Default: false
#   priority  What yum priority should this repo get?  Lower is "better".
#             Default: 80
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
#   class { 'rpmrepos::cms_osg': itb => true }
#     -or-
#   include rpmrepos::cms_osg
#
class rpmrepos::cms_osg (
  $baseurl   = 'http://cms-install.fnal.gov/cobbler/repo_mirror',
  $enabled   = '1',
  $itb       = false,
  $priority  = '80',
  $proxy     = 'absent',
) {
  validate_bool   ($enabled, $itb)
  validate_string ($baseurl, $proxy, $priority)

  ensure_packages ( ['yum-plugin-priorities'] )

  if str2bool($itb) {
    $url = "${baseurl}/uscmst1-osg${::lsbmajdistrelease}-itb"
  } else {
    $url = "${baseurl}/uscmst1-osg${::lsbmajdistrelease}"
  }
  $gpgkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG'

  if $::osfamily == 'RedHat' {
    yumrepo { 'osg':
      baseurl  => $url,
      proxy    => $rpmrepos::osg::proxy,
      enabled  => $rpmrepos::osg::enabled,
      priority => $rpmrepos::osg::priority,
      gpgcheck => '0',
      gpgkey   => "file://${gpgkey}",
      descr    => "OSG RPMs for SL ${::lsbmajdistrelease} - ${::architecture}",
      require  => Class['rpmrepos::epel']
    }

    file { $gpgkey:
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/rpmrepos/RPM-GPG-KEY-OSG',
    }

    rpmrepos::rpm_gpg_key { 'OSG': path => $gpgkey }

  } else {
    notice ("${::operatingsystem}: not compatible with OSG repo")
  }
}
