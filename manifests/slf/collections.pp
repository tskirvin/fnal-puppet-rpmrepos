# rpmrepos::slf::collections
#
#   Enable the SLF Collections repository (using yumrepo) and import
#   relevant GPG keys.
#
# == Parameters
#
#   enabled   Gets passed to yumrepo.  Default: true
#   priority  What yum priority should this repo get?  Lower is "better".
#             Default: 95
#   proxy     Gets passed to yumrepo.  Default: 'absent'
#
# == Requirements
#
#   You must be running a RHEL variant - CentOS, RHEL, Scientific, SLF, Oracle,
#   Ascendos, etc.  Also, since this should have been installed from SLF in the
#   first place, the GPG keys must already exist on-system.
#
#   puppetlabs-stdlib
#
# == Usage
#
#   include rpmrepos::slf::collections
#
class rpmrepos::slf::collections (
  $enabled  = true,
  $priority = '95',
  $proxy    = 'absent'
) {
  validate_bool   ($enabled)
  validate_string ($proxy, $priority)

  $base_http   = 'http://linux1.fnal.gov/linux/fermi/slf6x/external_products/softwarecollections/'
  $base = [ $base_http ]

  # generate the list of gpg keys
  $base_gpgkey = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY'
  $gpg_list = ['-sl', "-sl${::lsbmajdistrelease}", '-cern' ]
  $gpgkey = join ( prefix ($gpg_list, $base_gpgkey), ' ')

  if $::osfamily == 'RedHat' {
    yumrepo { 'slf-collections':
      baseurl  => join( suffix ($base, '/$basearch/'), ' '),
      descr    => 'SLF Software Collections - \$basearch',
      enabled  => $enabled,
      gpgcheck => true,
      gpgkey   => $gpgkey,
      priority => $priority,
      proxy    => $proxy,
    }
  } else {
    notice ("${::operatingsystem}: not compatible with SLF collections repo")
  }
}
