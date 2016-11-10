FROM

RUN apt-get update \
	&& apt-get install build-essential curl git clang checkinstall cmake python --no-install-recommends \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*
