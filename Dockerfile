FROM ubuntu:18.04

MAINTAINER Wanderson Bragança "wanderson.wbc@gmail.com"

USER root

ARG TEXLIVE_YEAR=2019

RUN set -ex; \
	apt-get -qq update; \
	apt-get -y upgrade; \
	apt-get install -y --no-install-recommends \
	software-properties-common \
	language-pack-en-base \
	locales \
	locales-all

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
	&& locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV MANPATH=$MANPATH:/usr/local/texlive/${TEXLIVE_YEAR}/texmf-dist/doc/man 
ENV INFOPATH=$INFOPATH:/usr/local/texlive/${TEXLIVE_YEAR}/texmf-dist/doc/info

ADD texlive.profile /

RUN set -ex; \
	apt-get install -y --no-install-recommends \
		apt-utils \
		locales \
		imagemagick \
		build-essential \
		wget \
		tar \
		perl \
	&& mkdir -p install-tl \
	&& wget -nv -O install-tl.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
	&& tar -xzf install-tl.tar.gz -C install-tl --strip-components=1 \
	&& cd install-tl/ \
	&& ./install-tl --persistent-downloads --profile /texlive.profile \
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
	/texlive.profile \
	/var/lib/apt/lists/* \
	/tmp/* \
	/var/tmp/* \
	&& rm /var/log/lastlog /var/log/faillog

CMD ["/bin/bash"]
