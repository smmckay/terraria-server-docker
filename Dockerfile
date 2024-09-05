FROM alpine:3.20 AS builder

ARG TERRARIA_VERSION=1449

RUN apk add curl unzip
RUN curl -L https://terraria.org/api/download/pc-dedicated-server/terraria-server-${TERRARIA_VERSION}.zip \
        -o /tmp/terraria-server-${TERRARIA_VERSION}.zip
RUN unzip /tmp/terraria-server-${TERRARIA_VERSION}.zip -d /tmp
RUN mkdir -p /opt/TerrariaServer
RUN cp -R /tmp/${TERRARIA_VERSION}/Linux/* /opt/TerrariaServer
RUN chmod +x /opt/TerrariaServer/TerrariaServer.bin.x86_64

FROM debian:bookworm

COPY --from=builder /opt/TerrariaServer /opt/TerrariaServer
ENTRYPOINT ["/opt/TerrariaServer/TerrariaServer.bin.x86_64"]
