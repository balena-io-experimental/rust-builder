#!/bin/bash

# Jenkins build steps

for ARCH in $ARCHS
do
	case "$ARCH" in
		'armv6hf')
			sed -e s~#{FROM}~resin/rpi-raspbian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'armv7hf')
			sed -e s~#{FROM}~resin/armv7hf-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'armel')
			sed -e s~#{FROM}~resin/armel-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'aarch64')
			sed -e s~#{FROM}~resin/aarch64-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'i386')
			sed -e s~#{FROM}~resin/i386-debian:latest~g Dockerfile.debian.tpl > Dockerfile
		;;
		'alpine-armhf')
			sed -e s~#{FROM}~resin/armhf-alpine:latest~g Dockerfile.alpine.tpl > Dockerfile
		;;
		'alpine-i386')
			sed -e s~#{FROM}~resin/i386-alpine:latest~g Dockerfile.alpine.tpl > Dockerfile
		;;
		'alpine-amd64')
			sed -e s~#{FROM}~resin/amd64-alpine:latest~g Dockerfile.alpine.tpl > Dockerfile
		;;
	esac
	docker build -t rust-$ARCH-builder .
	for RUST_VERSION in $RUST_VERSIONS
	do
		docker run --rm -e ARCH=$ARCH \
						-e ACCESS_KEY=$ACCESS_KEY \
						-e SECRET_KEY=$SECRET_KEY \
						-e BUCKET_NAME=$BUCKET_NAME rust-$ARCH-builder bash build.sh $RUST_VERSION
	done
done

# Clean up builder image after every run
docker rmi -f rust-$ARCH-builder
