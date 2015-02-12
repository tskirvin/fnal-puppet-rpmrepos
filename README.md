# fnal-puppet-rpmrepos

This repository provides a number of manifests to load to enable various
RPM repositories in use by DCSO and/or CMS.

## Classes

### rpmrepos::cms\_epel + rpmrepos::epel

Tracks the CMS EPEL mirror.  

### rpmrepos::cms\_osg + rpmrepos::osg

Tracks the CMS OSG mirror.

### rpmrepos::cms\_puppet + rpmrepos::puppet

Tracks the CMS Puppet mirror.

### rpmrepos::fermi\_testing

Tracks the fermi-testing repo.

### rpmrepos::slf

Tracks the main Scientific Linux (SLF) repos.

### rpmrepos::slf::collections

Tracks the SLF Colletions repository.

### rpmrepos::uscmst1

Tracks the USCMS-T1 "local" repository.

## Definitions

### rpmrepos::rpm\_gpg\_key

Loads GPG keys into the local RPM database.
