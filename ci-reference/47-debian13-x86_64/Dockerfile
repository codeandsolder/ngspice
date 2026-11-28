ARG BASE
FROM ${BASE}
RUN apt-get update \
 && apt-get install -y --no-install-recommends flex=2.6.4-8.2+b4 bison=2:3.8.2+dfsg-1+b2 ripgrep=14.1.1-1+b4 \
 && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
 && dpkg-query -W -f='${binary:Package}=${Version}\n' | sort > /usr/share/sccache-runtime/packages.txt
