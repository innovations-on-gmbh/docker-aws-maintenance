FROM mongo:6

ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem /rds-combined-ca-bundle.pem

COPY --chown=root:root scripts/connect.sh /
