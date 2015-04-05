#! /bin/sh

set -e
cake build &
sass css/main.scss >css/main.css  &

wait

echo "Done $(date)"


