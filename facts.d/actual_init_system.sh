#!/bin/bash

systemctl_stderr='/tmp/systemctl.err'
service_stderr='/tmp/service.err'

systemctl start foo 2> ${systemctl_stderr} 
service foo start 2> ${service_stderr} 

systemctl_not_init_msg="System has not been booted with systemd as init system (PID 1)."
systemctl_invalid_service_msg="Failed to start foo.service: Unit foo.service not found."
service_not_init_msg="service: command not found"
service_invalid_service_msg="foo: unrecognized service"

cat ${systemctl_stderr} | grep -q "${systemctl_not_init_msg}"
systemctl_not_init="$?"

cat ${systemctl_stderr} | grep -q "${systemctl_invalid_service_msg}"
systemctl_invalid_service="$?"

cat ${service_stderr} | grep -q "${service_not_init_msg}"
service_not_init="$?"

cat ${service_stderr} | grep -q "${service_invalid_service_msg}"
service_invalid_service="$?"

if [[ ${systemctl_not_init} -ne 0 ]];
then
  if [[ ${systemctl_invalid_service} -eq 0 ]];
  then service_provider='systemd'
  fi
elif [[ ${service_not_init} -ne 0 ]];
then
  if [[ ${service_invalid_service} -eq 0 ]];
  then service_provider='upstart'
  fi
fi

echo ${service_provider}
