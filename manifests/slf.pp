# rpmrepos::slf
#
#   Enable the main SLF (Scientific Linux Fermi) repositories (using yumrepo) and
#   import relevant GPG keys.  This includes:
#
#     * slf
#     * slf-security
#     * slf-source
#
# == Parameters
#
#   enabled   Gets passed to yumrepo.  Default: 1
#   floating  If true, we track the 'x' branch, meaning that we automatically
#             follow from SLF 6.3 to 6.4.  Default: true.
#   priority  What yum priority should this repo get?  Lower is "better".
#             Default: 10
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
#   class { 'rpmrepos::slf': floating => true }
#
class rpmrepos::slf (
  $enabled  = '1',
  $floating = true,
  $priority = '10',
  $proxy    = 'absent'
) {
  validate_bool   ($enabled, $floating)
  validate_string ($proxy, $priority)

  if $floating { $slf = "slf${::lsbmajdistrelease}x" }
  else         { $slf = "slf${::lsbdistrelease}"     }

  $base_http   = "http://linux1.fnal.gov/linux/fermi/${slf}"
  $base_ftp1   = "ftp://linux1.fnal.gov/linux/fermi/${slf}"
  $base_ftp2   = "ftp://linux.fnal.gov/linux/fermi/${slf}"

  $base = [ $base_http, $base_ftp1, $base_ftp2 ]

  # generate the list of gpg keys
  $base_gpgkey = 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY'
  $gpg_list = ['-sl', "-sl${::lsbmajdistrelease}", '-cern' ]
  $gpgkey = join ( prefix ($gpg_list, $base_gpgkey), ' ')

  if $::osfamily == 'RedHat' {
    yumrepo { 'slf':
      baseurl  => join( suffix ($base, '/$basearch/os/'), ' '),
      descr    => "Scientific Linux Fermi ${slf} - \$basearch - \$basearch",
      enabled  => $enabled,
      gpgcheck => '1',
      gpgkey   => $gpgkey,
      priority => $priority,
      proxy    => $proxy,
    }

    yumrepo { 'slf-security':
      baseurl  => join( suffix ($base, '/$basearch/updates/security/'), ' '),
      descr    => "Scientific Linux Fermi ${slf} - \$basearch - security",
      enabled  => $enabled,
      gpgcheck => '1',
      gpgkey   => $gpgkey,
      priority => $priority,
      proxy    => $proxy,
    }

    yumrepo { 'slf-source':
      baseurl  => join( suffix ($base, '/SRPMS/'), ' '),
      descr    => "Scientific Linux Fermi ${slf} - Source",
      enabled  => $enabled,
      gpgcheck => '1',
      gpgkey   => $gpgkey,
      priority => $priority,
      proxy    => $proxy,
    }
  } else {
    notice ("${::operatingsystem}: not compatible with SLF repo")
  }
}
