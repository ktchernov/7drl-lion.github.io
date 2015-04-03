#! /bin/sh

set -ex
cake build &
sass css/main.scss >css/main.css  &

wait

