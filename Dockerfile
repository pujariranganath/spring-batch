FROM openjdk:8-jre-alpine
# Set the working directory to /app
WORKDIR /app
ADD target/dependency-jars/* /app/target/dependency-jars/
ADD target/spring-batch.jar /app/target/
ADD csv/inputs/* /app/csv/inputs/
ADD csv/outputs/* /app/csv/outputs/
ADD test_batch.sh /app/test_batch.sh
#COPY credentials /root/.aws/credentials
#COPY config /root/.aws/config
RUN apk add --no-cache --upgrade bash
RUN apk --no-cache add curl
RUN sed -i 's/\r$//' /app/test_batch.sh
RUN apk update && apk add \
	ca-certificates \
	groff \
	less \
	python \
	py-pip \
	&& rm -rf /var/cache/apk/* \
  && pip install pip --upgrade \
  && pip install awscli
CMD ["sh", "test_batch.sh"]