FROM python:2.7.18-slim-stretch
COPY /src   /opt/app

RUN chmod +x /opt/app/entrypoint.sh

#set timezone: https://serverfault.com/a/683651
ENV TZ="Europe/Amsterdam"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#Install Cron
RUN apt-get update
RUN apt-get -y install cron

# The OmnikExport script should not run at midnight. This is when the inverter resets its internal counters. If the time is ever so slightly off
# then the first reading for the next day still has the production values of the previous day resulting in Bad Requests HTTP 400: "Moon Powered" from pvoutput.org
#
# The first job would trigger every five minutes from hh:05 through to hh:55 every hour from 00 through to 23. This job skips every full hour
# The second job would trigger on the hour, every hour from 01:00 through to 23:00, but not at midnight. This would take care of the on-the-hour jobs that the first schedule skips.
#
# Add the cron jobs
# and redirect output to named pipes that will be created from entrypoint.sh.
RUN crontab -l | { cat; echo "5-55/5 0-23 * * * /usr/local/bin/python /opt/app/OmnikExport.py >/tmp/stdout 2>/tmp/stderr"; } | crontab -
RUN crontab -l | { cat; echo "0 1-23 * * * /usr/local/bin/python /opt/app/OmnikExport.py >/tmp/stdout 2>/tmp/stderr"; } | crontab -


ENTRYPOINT [ "/opt/app/entrypoint.sh" ]