# rpmrepos::rpm_gpg_key
#
#   Import GPG keys into the list of trusted RPM signing keys.
#
#   Note: there is no corresponding 'remove key' command.
#
# == Parameters
#
#   (name)    Name of the key, from the rpm database.
#   path      Where is the key to import?  Required, no default.
#
# == Usage
#
#   rpmrepos::rpm_gpg_key { "EPEL-${::os_maj_version}":
#     path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${::os_maj_version}"
#   }
#
define rpmrepos::rpm_gpg_key (
  $path = undef
) {
  validate_string ($name, $path)
  exec {  "import-${name}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import $path",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < $path) | awk ' { print \$2 } ' | awk -F/ ' { print \$2 } ' | tr '[A-Z]' '[a-z]')",
    require   => File[$path],
    logoutput => 'on_failure',
  }
}
