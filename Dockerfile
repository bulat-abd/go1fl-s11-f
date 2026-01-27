FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY *.go ./

#COPY tracker.db ./

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-s -w" -o  parcel_app .

FROM scratch
WORKDIR /app
# Copy the compiled binary from the builder stage
COPY --from=builder /app/parcel_app ./
COPY tracker.db ./
CMD ["./parcel_app"]