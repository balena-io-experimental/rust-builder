FROM #{FROM}

RUN apt-get update \
	&& apt-get install -y build-essential curl git clang checkinstall cmake python python-pip zlib1g-dev libedit-dev llvm-3.7-tools --no-install-recommends \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN pip install awscli

COPY . /
