---
title: "Learning PGP once for all"
date: 2018-06-22
draft: true
---
#pgp #blog #algolia

## Introduction
* Happy to have joined the API Clients Squad
* Explain what we are doing
* Quick intro to the release process
* Maven, PGP, Sonotype...
* Don't use PGP Suite for Mac

## PGP
* What is this?
* PGP/GPG
* Too many stuff on my machine already, let's start from scratch (remove `~/.gnupg/` and GnuPG installation.

```bash
brew search gnupg
brew search gpg
```

Wait what?

brew info -> same output -> OUF

Upon starting, `~/.gnupg/pubring.kbx` is created. What's this thing. `gpg --list-keys` to check that everything is clean... `~/.gnupg/trustdb.gpg` file is created... Come on. But at least, no key is listed.

Explanations on [Using the GNU Privacy Guard: GPG Configuration](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration.html) are not super clear but Ok.

## List public and private keys
```bash
# List public keys
gpg --list-public-keys
gpg --list-keys
gpg --list-key
gpg -k

# List secret (private) keys
gpg --list-secret-keys
gpg -K
```

* One line per key, no way
* `sec` means secret key
* `ssb` means secret subkey (not 100% sure what this is used for)
* `pub` means public key
* `sub` means public subkey
* did

## Sign something

## GnuPG <2.1 vs. 2.1+

## Notes
* `pubring.gpg` and `secring.gpg` vs. `purring.kbx` and `trustdb.gpg`. 
* [pubring.kbx, no secring?](https://lists.gnupg.org/pipermail/gnupg-users/2015-December/054881.html)
* `export GPG_TTY=$(tty)`
* [gpg: signing failed: Inappropriate ioctl for device · Issue #2798 · keybase/keybase-issues · GitHub](https://github.com/keybase/keybase-issues/issues/2798)
* [ssh - Gentoo Linux GPG encrypts properly a file passed through parameter but throws "Inappropriate ioctl for device" when reading from standard input - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/257061/gentoo-linux-gpg-encrypts-properly-a-file-passed-through-parameter-but-throws-i/257065#257065)
