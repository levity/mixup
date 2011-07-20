# each client has an avatar (a glorified cursor)
# on mouseover: have the avatar follow the cursor
# update all clients with avatar movements

fs      = require 'fs'
nowjs   = require 'now'
express = require 'express'

app = express.createServer()
app.get '/', (req, res) ->
  fs.readFile './index.html', 'utf8', (err, html) ->
    res.end html    
app.listen 8081

everyone = nowjs.initialize app
everyone.now.move = (ev) -> 
  everyone.now.seeMove this.now.name, ev
