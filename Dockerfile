FROM debian:buster-slim
ARG GHOSTSCRIPT_VERSION=10.0.0
ARG IMAGEMAGICK_VERSION=7.1.0-50

RUN apt-get update \
    && apt-get --no-install-recommends -y install ca-certificates curl build-essential pkg-config \
    && apt-get --no-install-recommends -y install libxml2-dev libxml2-utils libjpeg-dev libpng-dev libtiff-dev libgif-dev libraw-dev libwebp-dev ghostscript \
    && apt-get --no-install-recommends -y install fontconfig fonts-ipafont

#### See: https://ghostscript.com/releases/gsdnld.html
#RUN curl -sfLO https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$(echo $GHOSTSCRIPT_VERSION | sed "s/\.//g")/ghostscript-${GHOSTSCRIPT_VERSION}-linux-x86_64.tgz \
#    && tar xvzf ghostscript-${GHOSTSCRIPT_VERSION}-linux-x86_64.tgz \
#    && cp ghostscript-${GHOSTSCRIPT_VERSION}-linux-x86_64/gs-$(echo $GHOSTSCRIPT_VERSION | sed "s/\.//g")-linux-x86_64 /usr/local/bin/gs \
#    && rm -rf ghostscript-${GHOSTSCRIPT_VERSION}-linux-x86_64*

RUN curl -sfLO https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${IMAGEMAGICK_VERSION}.tar.gz \
    && tar xvzf ${IMAGEMAGICK_VERSION}.tar.gz \
    && cd ImageMagick-${IMAGEMAGICK_VERSION}  \
    && ./configure \
        --without-magick-plus-plus \
        --without-perl \
        --enable-openmp \
        --with-gvc=no \
        --disable-docs \
    && make -j$(nproc)\
    && make install \
    && ldconfig /usr/local/lib \
    && rm -rf /var/lib/apt/lists/* \
    && cd .. \
    && rm -rf ImageMagick* \
    && rm -rf ${IMAGEMAGICK_VERSION}.tar.gz
