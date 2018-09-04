FROM ubuntu:18.04

MAINTAINER Wanderson Bragança "wanderson.wbc@gmail.com"

USER root

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

ENV PATH=$PATH:/usr/local/texlive/2018/bin/x86_64-linux
ENV MANPATH=$MANPATH:/usr/local/texlive/2018/texmf-dist/doc/man
ENV INFOPATH=$INFOPATH:/usr/local/texlive/2018/texmf-dist/doc/info

RUN set -ex; mkdir -p install-tl

ADD texlive.profile install-tl

RUN set -ex; \
	apt-get -qq update \
	&& apt-get install -qq -y --no-install-recommends \
		apt-utils \
		locales \
		build-essential \
		imagemagick \
		wget \
		tar \
		perl \
	&& locale-gen en_US.UTF-8 \
	&& wget -nv -O install-tl.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
	&& tar -xzf install-tl.tar.gz -C install-tl --strip-components=1 \
	&& cd install-tl/ \
	&& ./install-tl --persistent-downloads --profile texlive.profile \
	&& cd / \
	&& apt-get -qq -y --allow-remove-essential remove \
		build-essential \
		apt-utils \
		wget \
		perl \
	&& apt-get autoclean \
	&& apt-get --purge -y autoremove \
	&& apt-get clean \
	&& rm -rf /install-tl.tar.gz \
		/install-tl \
		/var/lib/apt/lists/* \
		/tmp/* \
		/var/tmp/* \
	&& rm /var/log/lastlog /var/log/faillog

CMD ["/bin/bash"]
