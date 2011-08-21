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

playerPositions = {}

everyone.now.move = (ev) -> 
  everyone.now.seeMove this.now.name, ev
  playerPositions[this.now.name] = ev

nowjs.on 'disconnect', ->
  everyone.now.remove this.now.name

npcPos = {x: 0.1, y: 0.1}

closestPlayerToNpc = ->
  bestDistance = 2
  closestPlayer = null
  for name, ev of playerPositions
    console.log(name + ' ' + ev)
    distance = Math.sqrt(Math.pow(ev.x - npcPos.x, 2) + Math.pow(ev.y - npcPos.y, 2))
    if distance < bestDistance
      bestDistance = distance
      closestPlayer = ev
  [bestDistance, closestPlayer]
  
    
updateNpcPosition = ->
  # date = new Date() / 1000
  # {
  #   x: 0.5 + 0.3 * Math.sin(date + 3.14),
  #   y: 0.5 + 0.3 * Math.cos(date)
  # }
  npcSpeed = 0.02
  [distance, target] = closestPlayerToNpc()
  npcPos = {
    x: npcPos.x + (target.x - npcPos.x) * npcSpeed / distance,
    y: npcPos.y + (target.y - npcPos.y) * npcSpeed / distance
  }
  npcPos

gameLoop = ->
  # everyone.now.seeMove 'NPC', {x: 0.5, y: 0.5}
  everyone.now.seeMove 'NPC', updateNpcPosition()
  
setInterval gameLoop, 25

