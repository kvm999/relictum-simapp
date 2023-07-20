FROM golang:1.19-alpine AS builder

RUN apk add --update --no-cache ca-certificates git make

WORKDIR /app

COPY . .

RUN cd relictumd && go build

FROM alpine:3.18.0

RUN apk add --update --no-cache ca-certificates jq

COPY --from=builder /app/relictumd/relictumd /usr/local/bin/relictumd
COPY --from=builder /app/scripts/gen-keys.sh /usr/local/bin/gen-keys.sh
RUN chmod +x /usr/local/bin/gen-keys.sh

EXPOSE 26656 26657 26658
