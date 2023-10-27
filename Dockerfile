FROM amazon/aws-cli:latest

WORKDIR /
ADD ./ /

COPY build.sh /build.sh
ENTRYPOINT ["sh", "/build.sh"]
