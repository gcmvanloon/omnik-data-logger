# Omnik-Data-Logger in a container
Omnik Data Logger is a small script for uploading data from a Omniksol Solar inverter, equipped with a wifi module, to a database and/or to PVoutput.org.
The script is originally written by github user Woutrrr. See source [here](https://github.com/Woutrrr/Omnik-Data-Logger). 

This container took the script from Woutrrr and runs it every 5 minutes using a cron job.
The container makes it easy to run the script on a NAS system that supports docker containers.

## Cron Job output
All output from the job is redirected to the docker logs. This way you can configure the script to log to the console and still be able to read the logs.

## Timezone
PVOutput requires you to use local time when uploading your measurements.
Set an Environment Variable named `TZ` with your timezone in order to get your measurements with the correct timestampt in local time.

## Volumes
You should mount a volume on `/config`. The Python script is hard coded to look for a config file at this location.

# Building
To build this container yourself:
`docker build . --tag omnik-data-logger`

# Running
To run this container with the required volume and environment variable
`docker run -d -v [host path]:/config -e TZ=Europe/Amsterdam --name omnik omnik-data-logger:latest`

# Configuration
The data logger is configured by a config.cfg file that must be placed in `/config`.
Here is a sample config.cfg file for your convenience
```
################
### Settings ###
################

[general]
# General:enabled_plugins
# Choose which outputs to use
# Possible options: MysqlOutput,PVoutputOutput,ConsoleOutput,CSVOutput
enabled_plugins = PVoutputOutput

[inverter]
# IP address of your Omnik inverter
ip = 192.168.1.10
# Default for a Omnik with Wifi module
port = 8899
# S/N of the wifi kit
wifi_sn = 602123456
#use temperature of inverter for pvoutput
use_temperature = true

[mysql]
# Host where the mysql server is active
host = 127.0.0.1
user =
pass =
database =

[pvout]
# These two can be found at http://pvoutput.org/account.jsp
apikey = NOTAREALAPIKEY86e2258d4e29169fb79cf18b00
sysid  = 12345

[csv]
disable_header = false

[log]
# Log:Output
# Possible options: none,console,file (combinations are possible)
# Use none to disable logging
type = console

# Log:level
# Possible options: critical, error, warning, info, debug
level = debug

# Log:filename
# Output file for file logger
filename = omnik-export.log
```


