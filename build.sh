#!/bin/bash
set -e
set -o pipefail

# set env var
RUST_VERSION=$1
TAR_FILE=rust-$RUST_VERSION-$ARCH-linux.tar.gz
BUCKET_NAME=$BUCKET_NAME

# comparing version: http://stackoverflow.com/questions/16989598/bash-comparing-version-numbers
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" == "$1"; }
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | tail -n 1)" != "$1"; }

mkdir rust
curl -SLO "https://static.rust-lang.org/dist/rustc-$RUST_VERSION-src.tar.gz"
echo "$(grep " rustc-$RUST_VERSION-src.tar.gz" /checksums-commit-table)" | sha256sum -c -
tar -xzvf rustc-$RUST_VERSION-src.tar.gz -C rust --strip-components=1

cd rust
CC=clang CXX=clang++ ./configure --disable-libcpp --enable-clang --prefix=/
make -j$(nproc) all
make install
cd /
tar -cvzf $TAR_FILE rust/*

curl -SLO "http://resin-packages.s3.amazonaws.com/SHASUMS256.txt"
sha256sum $TAR_FILE >> SHASUMS256.txt

# Upload to S3 (using AWS CLI)
printf "$ACCESS_KEY\n$SECRET_KEY\n$REGION_NAME\n\n" | aws configure
aws s3 cp $TAR_FILE s3://$BUCKET_NAME/rust/v$RUST_VERSION/
aws s3 cp SHASUMS256.txt s3://$BUCKET_NAME/
