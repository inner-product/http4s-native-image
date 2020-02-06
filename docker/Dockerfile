# Dockerfile to build an image that runs the GraalVM native-image compiler. We
# need to do this because native-image only builds on the platform on which it
# runs. Hence if we want to build Linux binaries on a different machine we need
# to create a Linux VM that does this. This is what we are doing here.
#
# To build this image, run:
#
#   docker build -t inner-product/graalvm-native-image .
#
ARG GRAAL_VERSION=19.3.1-java11
FROM oracle/graalvm-ce:${GRAAL_VERSION}
WORKDIR /opt/native-image
RUN gu install native-image
ENTRYPOINT ["native-image"]
