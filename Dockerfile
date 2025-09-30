# Build stage
FROM golang:1.22.5 AS builder

WORKDIR /app

COPY go.mod .
RUN go mod download

COPY . .
# Force build for Linux AMD64 (common for servers)
RUN GOOS=linux GOARCH=amd64 go build -o /main .

# Final stage with Distroless image
FROM gcr.io/distroless/base

WORKDIR /
COPY --from=builder /main .
COPY --from=builder /app/static ./static

EXPOSE 8080

# Distroless requires absolute path
CMD ["/main"]
