FROM sonarqube:6.7-alpine

COPY bin/run.sh $SONARQUBE_HOME/bin/

RUN chown -R sonarqube:0 $SONARQUBE_HOME && \
    chmod -R g+rw $SONARQUBE_HOME && \
    find $SONARQUBE_HOME -type d -exec chmod g+x {} + && \
    chmod 775 $SONARQUBE_HOME/bin/run.sh

USER sonarqube
