FROM alpine:3.11.3
COPY ping-server /opt/ping-server/ping-server
RUN chmod +x /opt/ping-server/ping-server
EXPOSE 8080
ENTRYPOINT ["/opt/ping-server/ping-server"]
