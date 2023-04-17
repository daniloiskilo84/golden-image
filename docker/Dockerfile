FROM alpine:3.8

ARG PACKER_VERSION=1.8.2
ARG PACKER_PACKAGE=packer_${PACKER_VERSION}_linux_amd64.zip
ARG PACKER_URL=https://releases.hashicorp.com/packer/${PACKER_VERSION}/${PACKER_PACKAGE}

ENV PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/packer/.local/bin'

RUN apk update && apk upgrade && \
  apk add bash git python3 python3-dev ruby openssh-client openssl \
  py3-paramiko py3-psutil py3-pluggy py3-bcrypt py3-pynacl \
  py3-cryptography py3-cffi py3-docutils py3-rsa py3-click py3-dateutil \
  py3-urllib3 py3-markupsafe py3-pygit2 py3-future py-futures py3-requests \
  py3-ptyprocess py3-mccabe py3-pyflakes py3-chardet py3-certifi \
  py3-atomicwrites py3-attrs py3-py py-openssl \
  ruby-io-console ruby-json ruby-ffi ruby-concurrent-ruby \
  ruby-multi_json ruby-etc ruby-rspec ruby-rspec-support ruby-rspec-core \
  ruby-rspec-expectations ruby-rspec-mocks ruby-dev libstdc++ g++ make && \
  pip3 install boto botocore boto3 awscli ansible molecule && \
  apk del ruby-dev libstdc++ g++ && \
  wget -c -q -O /tmp/${PACKER_PACKAGE} ${PACKER_URL} && \
  unzip /tmp/${PACKER_PACKAGE} && \
  cp packer /usr/local/bin && \
  rm /tmp/${PACKER_PACKAGE} packer && \
  adduser -h /packer -s /bin/bash -D packer && \
  apk del ruby-dev libstdc++ g++

USER packer
