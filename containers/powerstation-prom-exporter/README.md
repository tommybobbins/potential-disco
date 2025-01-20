$ podman build -t powerstation-prom-exporter:latest .
$ podman container list
$ podman run -d -p 9200:8080 powerstation-prom-exporter:latest 
$ podman run -d -p 9200:9200 powerstation-prom-exporter:latest 
$ podman container stop f6d7168f0046
$ curl localhost:9200

