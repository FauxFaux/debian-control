#!/bin/sh
set -eu

url=$1
out=$2

D=$(mktemp -d --tmpdir="$(dirname "$out")" --suffix=.extract)
trap 'rm -rf '"$D" EXIT

mkdir -p "$out"

curl -s "$url" \
    | bsdtar -Oxf /dev/stdin \
            --exclude=debian-binary \
            --exclude=data.tar.gz \
            --exclude=data.tar.bz2 \
            --exclude=data.tar.xz \
        | bsdtar -xf /dev/stdin \
            --exclude=md5sums \
            --exclude=symbols \
            --exclude=templates \
#            --exclude=control \
            -C "$D"

mv --no-target-directory "$D" "$out"

# We could leave an empty directory, which will trick ninja
# into thinking it's done, but git won't track? That might work.
#rmdir --ignore-fail-on-non-empty "$out" # if it's empty

