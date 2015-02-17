# rpmrepos::fermi_testing
#
#   Configures the fermi-testing and fermi-testing-source repositories.  You
#   probably want to use these manually.
#
# == Parameters
#
#   enabled   Should we enable this repo?  Default: 0
#   priority  What yum priority should this repo get?  Lower is "better".
#             Default: '5'
#   proxy     Default: 'absent'
#
class rpmrepos::fermi_testing (
  $enabled  = '0',
  $priority = '5',
  $proxy    = 'absent'
) {
  validate_string ($enabled, $priority, $proxy)

  $slf = "slf${::lsbmajdistrelease}"

  $base_http   = "http://linux1.fnal.gov/linux/fermi/${slf}rolling"
  $base_ftp1   = "ftp://linux1.fnal.gov/linux/fermi/${slf}rolling"
  $base_ftp2   = "ftp://linux.fnal.gov/linux/fermi/${slf}rolling"

  $base = [ $base_http, $base_ftp1, $base_ftp2 ]

  # generate the list of gpg keys
  $base_gpgkey = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY'
  $gpg_list = ['-sl', "-sl${::lsbmajdistrelease}" ]
  $gpgkey = join ( prefix ($gpg_list, $base_gpgkey), ' ')

  if $::osfamily == 'RedHat' {
    yumrepo { 'fermi-testing':
      baseurl  => join( suffix ($base, '/testing/$basearch/'), ' '),
      descr    => "Scientific Linux Fermi \$releasever Testing - \$basearch",
      enabled  => $enabled,
      gpgcheck => '1',
      gpgkey   => $gpgkey,
      priority => $priority,
      proxy    => $proxy
    }

    yumrepo { 'fermi-testing-source':
      baseurl  => join( suffix ($base, '/testing/SRPMS/'), ' '),
      descr    => "Scientific Linux Fermi ${slf} - \$basearch - security",
      enabled  => $enabled,
      gpgcheck => '1',
      gpgkey   => $gpgkey,
      priority => $priority,
      proxy    => $proxy,
    }
  } else {
    notice ("${::operatingsystem}: not compatible with fermi-testing repo")
  }
}
