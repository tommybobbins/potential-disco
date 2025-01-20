FROM golang:1.23
# Before running#############
#go mod init learn
#go mod tidy
#############################
WORKDIR /go/src/app
COPY go.mod go.sum .
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /ppe
EXPOSE 9200 
CMD ["/ppe"]

