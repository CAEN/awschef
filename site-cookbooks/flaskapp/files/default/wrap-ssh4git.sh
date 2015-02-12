#!/usr/bin/env bash
/usr/bin/env ssh -o "StrictHostKeyChecking=no" -i "/tmp/.appstack_deploy/.ssh/deployKey" $1 $2
