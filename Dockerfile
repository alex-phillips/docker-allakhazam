FROM lsiobase/nginx:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
ARG allakhazam_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	php7 \
    php7-mysqli && \
 echo "**** install allakhazam ****" && \
 mkdir -p /app/allakhazam && \
 if [ -z ${allakhazam_RELEASE+x} ]; then \
	allakhazam_RELEASE=$(curl -sX GET "https://api.github.com/repos/Akkadius/EQEmuAllakhazamClone/commits/master" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 	/tmp/allakhazam.tar.gz -L \
	"https://github.com/Akkadius/EQEmuAllakhazamClone/archive/${allakhazam_RELEASE}.tar.gz" && \
 tar xf \
 	/tmp/allakhazam.tar.gz -C \
	/app/allakhazam/ --strip-components=1 && \
 cd /app/allakhazam && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /
