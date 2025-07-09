FROM mongo:8

ADD https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem /global-bundle.pem

COPY --chown=root:root scripts/connect.sh /
