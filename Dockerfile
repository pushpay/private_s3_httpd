FROM golang:1.8.1-alpine as builder

RUN apk update && apk add git bash

RUN go get github.com/constabulary/gb/...

COPY ./ /src

WORKDIR /src

RUN if [ -d "/src/vendor" ]; then rm -Rf /src/vendor; fi

RUN ./vendor.sh

RUN gb build


FROM alpine:3.7

COPY --from=builder /src/bin/private_s3_httpd /

RUN chmod +x /private_s3_httpd

ENTRYPOINT ["/private_s3_httpd"]