# 
# Module Dependencies
# 
{exec, spawn} = require 'child_process'
fs     = require 'fs'
path   = require 'path'

# Output directory
OUTPUT = path.resolve 'build'

files =
  jade: [
    'example/index.jade'
  ]
  coffee: [
    'src/vand.coffee'
  ]


task 'build:jade', 'compiles jade files', ->
  files.jade.forEach (file) ->
    jade = ['jade', '-p', file, '-O', OUTPUT, file]
    exec jade.join(' '), (err, stdout, stderr) ->
      throw err          if err
      console.log stdout if stdout
      console.log stderr if stderr

task 'build:coffee', 'compiles coffeescript files', ->
  files.coffee.forEach (file) ->
    coffee = ['coffee', '-co', OUTPUT, file]
    exec coffee.join(' '), (err, stdout, stderr) ->
      throw err          if err
      console.log stdout if stdout
      console.log stderr if stderr
    
  
task 'build', 'compiles source files', ->
  invoke 'build:jade'
  invoke 'build:coffee'

task 'watch:coffee', 'watches for changes in source files', ->
  #coffescript has a built in watch function
  coffee = spawn 'coffee', ['-cw', '-o', OUTPUT, files.coffee[0]]
  coffee.stdout.on 'data', (data) -> console.log data.toString().trim()
  
  
  watch = (file) ->
    fs.watchFile file, (curr, prev) ->
      if curr.mtime > prev.mtime
        invoke 'build:jade'
  
  #watch file for file in files.jade                     
  