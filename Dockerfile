FROM debian:bookworm AS builder

ARG TERRARIA_VERSION=1449

RUN apt update
RUN apt install -y curl unzip
RUN curl -L https://terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_VERSION}.zip \
        -o /tmp/terraria-server-${TERRARIA_VERSION}.zip
RUN unzip /tmp/terraria-server-${TERRARIA_VERSION}.zip -d /tmp
RUN mkdir -p /opt/TerrariaServer
RUN cp -R /tmp/${TERRARIA_VERSION}/Linux/* /opt/TerrariaServer
RUN chmod +x /opt/TerrariaServer/TerrariaServer.bin.x86_64

FROM debian:bookworm

ADD https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl

COPY --from=builder /opt/TerrariaServer /opt/TerrariaServer
ENTRYPOINT ["/opt/TerrariaServer/TerrariaServer.bin.x86_64"]
