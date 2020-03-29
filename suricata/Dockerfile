# Dockerfile.suricata to build a Suricata docker container

# Set the base image to Ubuntu
FROM ubuntu

# File Author
MAINTAINER gradiuscypher

# Update the repos
RUN apt update && \
    apt install -y software-properties-common wget apt-transport-https && \
    # Add the Elastic key for Filebeat and add repo
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - && \
    echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list && \
    add-apt-repository -y ppa:oisf/suricata-stable && \
    apt update && apt install -y suricata supervisor logrotate cron && \
    # remove invalid stuff
    sed -i'' '/SURICATA TLS invalid handshake message/s/^/#/g' /etc/suricata/rules/tls-events.rules && \
    sed -i'' '/SURICATA TLS invalid record\/traffic/s/^/#/g' /etc/suricata/rules/tls-events.rules

# forward request and error logs to docker log collector
#RUN ln -sf /dev/stdout /var/log/suricata/suricata.log
#    && ln -sf /dev/stderr /var/log/suricata/error.log

ADD logrotate.d /etc/logrotate.d/
ADD cron.d /etc/cron.d/

# Download the latest EmergingThreats ruleset
RUN wget --no-parent -l1 -r --no-directories -P /etc/suricata/rules/ https://rules.emergingthreats.net/open/suricata/rules/

VOLUME /var/log/suricata

RUN /usr/bin/suricata -V

#rule to test suricata
ADD emerging-icmp.rules /etc/suricata/rules/

# Start the Suricata/Filebeat service when the container is started
#CMD service suricata start && service filebeat start && tail -F /var/log/suricata/suricata.log
# Start suricata
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]