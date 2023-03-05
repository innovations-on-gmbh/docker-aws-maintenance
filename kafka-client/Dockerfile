FROM ubuntu:20.04

#TODO make configurable
ADD https://downloads.apache.org/kafka/3.3.2/kafka_2.13-3.3.2.tgz /kafka.tgz

RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-11-jre wget dnsutils netcat vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /kafka && tar xzvf kafka.tgz -C /kafka --strip-components=1

COPY log4j_debug.properties enable_kafka_debug /

COPY --chown=root:root scripts/render_config.sh scripts/describe_topic.sh scripts/list_topics.sh scripts/list_groups.sh /

ENV PATH="${PATH}:/kafka/bin:/"

CMD [ "/bin/bash", "-c", "/render_config.sh; /bin/bash" ]