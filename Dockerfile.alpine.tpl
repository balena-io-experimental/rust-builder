FROM #{FROM}

RUN apk add --update build-base curl git clang file cmake py-pip

# Install AWS CLI
RUN pip install awscli

COPY . /
