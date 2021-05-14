# Build Geth in a stock Go builder container
FROM golang:1.16-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /go-elleum
RUN cd /go-elleum && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-elleum/build/bin/geth /usr/local/bin/

EXPOSE 3798 3799 37988 37988/udp
ENTRYPOINT ["geth"]
