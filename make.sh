#!/bin/zsh
set -eu

M=/home/apt-mirror/mirror/debian.mirrors.ovh.net/debian
xzcat $M/dists/stretch/main/binary-amd64/Packages.xz \
    | awk '/^Filename/ { print $2 }' \
    | while read x; do
        d=${x/#pool\/main\//}
        d=${d:r}
        mkdir -p "$d"
        bsdtar -Oxf "$M/$x" control.tar.gz \
            | tar zx --exclude=md5sums \
                --exclude=symbols \
                --exclude=templates \
                --exclude=control \
                -C "$d"
    done

find -type d -empty | sed 's,$,/.empty,' | xargs touch

