#!/bin/bash

# reference: https://stackoverflow.com/a/63346931/6141720
# Create custom stdout and stderr named pipes
mkfifo /tmp/stdout /tmp/stderr
chmod 0666 /tmp/stdout /tmp/stderr

# Have the main Docker process tail the files to produce stdout and stderr 
# for the main process that Docker will actually show in docker logs.
tail -f /tmp/stdout &
tail -f /tmp/stderr >&2 &

# Run cron
cron -f

# Keep the container running forever
tail -f /dev/null