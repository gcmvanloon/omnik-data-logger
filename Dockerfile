FROM python:2.7.18-slim-stretch
COPY /src   /opt/app

RUN chmod +x /opt/app/entrypoint.sh

#set timezone: https://serverfault.com/a/683651
ENV TZ="Europe/Amsterdam"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Install Cron
RUN apt-get update
RUN apt-get -y install cron

# Add the cron job
# redirect output to named pipes that will be created from entrypoint.sh.
RUN crontab -l | { cat; echo "*/5 * * * * /usr/local/bin/python /opt/app/OmnikExport.py >/tmp/stdout 2>/tmp/stderr"; } | crontab -


ENTRYPOINT [ "/opt/app/entrypoint.sh" ]