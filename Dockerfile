FROM golang:1.15.2-alpine3.12 as builder

RUN mkdir /go/src/app
ADD . /go/src/app
WORKDIR /go/src/app/cmd/slackboard

ENV GO111MODULE=on
RUN apk update \
    && apk add --no-cache git

RUN go build -ldflags "-s -w" -o /go/src/app/slackboard

FROM alpine:3.12 as runner

RUN apk add --no-cache tzdata ca-certificates
RUN mkdir /app
COPY --from=builder /go/src/app/slackboard /

EXPOSE 29800
ENTRYPOINT ["/slackboard"]
CMD ["-c", "/app/slackboard.toml"]