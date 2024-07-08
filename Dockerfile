FROM golang:1.22 as build
LABEL maintainer="Simon Krenger <simon@krenger.ch>"
LABEL description="A small container that returns the environment variables plus some basic information on port 8080"

WORKDIR /go/src/github.com/rinormaloku/echoenv

# Copy go.mod and go.sum for dependency resolution
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY echoenv.go .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o /go/bin/echoenv .

FROM scratch
WORKDIR /
COPY --from=build /go/bin/echoenv .

ENV GIN_MODE release
ENV PORT 8080
EXPOSE $PORT
USER 1001
CMD ["./echoenv"]
