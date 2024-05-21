FROM debian:12 as downloader
WORKDIR /
RUN apt update && \
    apt install wget tar gzip && \
    wget https://github.com/syscoin/syscoin/releases/download/v4.4.2/syscoin-4.4.2-x86_64-linux-gnu.tar.gz && \
    tar xvf syscoin-4.4.2-x86_64-linux-gnu.tar.gz

FROM debian:12-slim
WORKDIR /
RUN mkdir -p syscoin/bin && \
    mkdir syscoin/include && \
    mkdir syscoin/lib && \
    mkdir -p syscoin/share/rpcauth
COPY --from=downloader /syscoin-4.4.2/bin/syscoind /syscoin/bin/syscoind
COPY --from=downloader /syscoin-4.4.2/bin/sysgeth /syscoin/bin/sysgeth
COPY --from=downloader /syscoin-4.4.2/include/syscoinconsensus.h /syscoin/include/syscoinconsensus.h
COPY --from=downloader /syscoin-4.4.2/lib/libsyscoinconsensus.so /syscoin/lib/libsyscoinconsensus.so
COPY --from=downloader /syscoin-4.4.2/lib/libsyscoinconsensus.so.0 /syscoin/lib/libsyscoinconsensus.so.0
COPY --from=downloader /syscoin-4.4.2/lib/libsyscoinconsensus.so.0.0.0 /syscoin/lib/libsyscoinconsensus.so.0.0.0
COPY --from=downloader /syscoin-4.4.2/share/rpcauth/rpcauth.py /syscoin/share/rpcauth/rpcauth.py
COPY --from=downloader /syscoin-4.4.2/syscoin.conf /syscoin/syscoin.conf
CMD /syscoin/bin/syscoind
