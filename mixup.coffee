# each client has an avatar (a glorified cursor)
# on mouseover: have the avatar follow the cursor
# update all clients with avatar movements

fs      = require 'fs'
nowjs   = require 'now'
express = require 'express'

app = express.createServer()

app.configure ->
  app.use express['static'](__dirname + '/static')

app.get '/', (req, res) ->
  fs.readFile './index.html', 'utf8', (err, html) ->
    res.end html

app.listen 9001

everyone = nowjs.initialize app

everyone.now.move = (ev) -> 
  everyone.now.seeMove this.now.name, ev

nowjs.on 'disconnect', ->
  everyone.now.remove this.now.name

npcPosition = {x: 0.1, y: 0.1}

gameLoop = ->
  date = new Date() / 1000
  # everyone.now.seeMove 'NPC', {x: 0.5, y: 0.5}
  everyone.now.seeMove 'NPC', {
    x: 0.5 + 0.3 * Math.sin(date + 3.14),
    y: 0.5 + 0.3 * Math.cos(date)
  }
  
setInterval gameLoop, 25

