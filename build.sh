#! /bin/sh

set -ex
sass css/main.scss >css/main.css 
cake build

