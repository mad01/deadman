FROM golang:1.14
WORKDIR /go/src/github.com/mad01/deadman

RUN go get golang.org/x/tools/cmd/goimports
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux make
RUN CGO_ENABLED=0 GOOS=linux make test

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=0 /go/src/github.com/mad01/deadman/_release/deadman /bin/deadman
ENTRYPOINT ["/bin/deadman"]
