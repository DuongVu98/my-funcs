# Stage 1: Download the func CLI
FROM alpine:3.18 AS builder

ARG FUNC_VERSION=v0.28.0

RUN apk add --no-cache curl ca-certificates \
 && update-ca-certificates

# Note the underscore in func_linux_amd64
RUN curl -fsSL \
    https://github.com/knative/func/releases/tag/knative-v1.18.1/func_linux_amd64 \
    -o /func \
 && chmod +x /func

# Stage 2: Final image with git + func
FROM alpine:3.18

RUN apk add --no-cache git ca-certificates \
 && update-ca-certificates

COPY --from=builder /func /usr/local/bin/func

# verify
RUN func version

ENTRYPOINT [ "sh", "-c" ]
