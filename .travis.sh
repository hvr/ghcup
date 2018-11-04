#!/bin/sh

edo()
{
	printf "\\033[0;34m%s\\033[0m\\n" "$*" 1>&2
    "$@" || exit 2
}

export BOOTSTRAP_HASKELL_NO_UPGRADE=1
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
edo mkdir -p "$HOME"/.ghcup/bin
edo cp ./ghcup "$HOME"/.ghcup/bin/ghcup

edo ./bootstrap-haskell
edo ghcup -v rm -f 8.6.1

# install GHCs
edo ghcup -v install 8.2.2
edo ghcup -v install 8.4.3
edo ghcup -v -c install 8.6.1

# set GHC
edo ghcup -v set 8.6.1
edo ghcup -v set 8.4.3

# rm GHC
edo ghcup -v rm -f 8.6.1
edo ghcup -v rm -f 8.4.3

# reinstall from cached tarball
edo ghcup -v -c install 8.6.1
edo ghcup -v rm -f 8.6.1

# set GHC
edo ghcup -v set 8.2.2

# install default GHC
edo ghcup -v install



# TODO: exceeds maximum time limit of travis
# compile GHC from source
#./ghcup -v compile 8.4.3 ghc-8.2.2

# install cabal-install
edo ghcup -v install-cabal

edo cabal --version

# install shellcheck
edo wget https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz
edo tar -xJf shellcheck-latest.linux.x86_64.tar.xz
edo mv shellcheck-latest/shellcheck "$HOME"/.local/bin/shellcheck

# check our script for errors
edo shellcheck ghcup

edo ghcup -v show

edo ghcup -v debug-info

edo ghcup -v list
edo ghcup -v list -t ghc
edo ghcup -v list -t cabal-install

edo ghc --version

# self update destructively
edo ghcup -v upgrade
