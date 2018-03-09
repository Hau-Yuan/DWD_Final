var express = require('express');
var app = express();
var WebSocket = require('ws');


var wss = new WebSocket.Server({ port: 1024 });

wss.on('connection', function(connection){
  console.log('user connected');
  connection.on('message',function(message){
    console.log(message);

    for (var client of wss.clients) {
      if (client.readyState === WebSocket.OPEN) {
        console.log('sending message to client')
        client.send(message);
      }
    }

  });

  connection.on('error', function() {
    // Don't need to do anything here. Just need it to prevent crashes.
  });
});

app.use(express.static('public'));

app.get('/', function (req, res) {
  res.send('Hello World!')
});

app.listen(3030, function () {
  console.log('Example app listening on port 3030!')
});
