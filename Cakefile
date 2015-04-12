fs = require 'fs'
Snockets = require 'snockets'

NAME = 'main'
INPUT_FILE = "js/#{NAME}.coffee"
OUTPUT_FILE = "js/#{NAME}.js"

task 'build', 'Build', ->
  snockets = new Snockets()
  js = snockets.getConcatenation INPUT_FILE, async: false, minify: true
  fs.writeFileSync OUTPUT_FILE, js

task 'clean', "remove #{OUTPUT_FILE}", ->
  fs.unlinkSync OUTPUT_FILE
