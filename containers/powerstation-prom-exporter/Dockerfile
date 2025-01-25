FROM golang:1.23 AS BuildStage
# Before running#############
#go mod init learn
#go mod tidy
#############################
WORKDIR /go/src/app
COPY go.mod go.sum .
RUN go mod download
COPY *.go ./
EXPOSE 9200 
RUN CGO_ENABLED=0 GOOS=linux go build -o /ppe

# Deploy Stage to slim down the 403MB
FROM alpine:latest
WORKDIR /
COPY --from=BuildStage /ppe /ppe
EXPOSE 9200
RUN useradd -ms /bin/bash app
user app:app
CMD ["/ppe"]
