FROM alpine:3.19.1

RUN apk update
RUN apk add squashfs-tools
RUN apk add xorriso

RUN mkdir /opt/work

WORKDIR /root/
COPY src/app.sh ./
COPY src/generate.sh ./

CMD [ "./app.sh" ]
