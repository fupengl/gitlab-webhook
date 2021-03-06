#!/usr/bin/env bash

### BEGIN INIT INFO
# Provides:   webhook
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the webhook service
# Description:       starts ebhook service using start-stop-daemon
### END INIT INFO

PATH=/usr/bin
DAEMON=/usr/sbin/webhook
NAME=webhook
DESC=webhook

test -x $DAEMON || exit 0

set -e

PID=/run/webhook.pid

start() {
    start-stop-daemon --start --quiet --pidfile $PID \
      --retry 5 --exec $DAEMON --oknodo -- $DAEMON_OPTS
}

stop() {
    start-stop-daemon --stop --quiet --pidfile $PID \
      --retry 5 --oknodo --exec $DAEMON
}

case "$1" in
  start)
    log_daemon_msg "Starting $DESC" "$NAME"
    start
    log_end_msg $?
    ;;

  stop)
    log_daemon_msg "Stopping $DESC" "$NAME"
    stop
    log_end_msg $?
    ;;

  restart)
    log_daemon_msg "Restarting $DESC" "$NAME"
    stop
    sleep 1
    start
    log_end_msg $?
    ;;

  reload)
    log_daemon_msg "Reloading $DESC configuration" "$NAME"
    start-stop-daemon --stop --signal HUP --quiet --pidfile $PID \
      --oknodo --exec $DAEMON
    log_end_msg $?
    ;;

  status)
    status_of_proc -p $PID "$DAEMON"
    ;;

  *)
    echo "Usage: $NAME {start|stop|restart|reload|status}" >&2
    exit 1
    ;;
esac

exit 0