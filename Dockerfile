FROM alpine:3.19.1

RUN apk update
RUN apk add squashfs-tools

WORKDIR /root/
COPY app.sh ./
COPY generate.sh ./

ENTRYPOINT [ "./app.sh" ]