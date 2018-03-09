var ship;
var asteroids = [];
var lasers = [];
var socket;
var url;

function setup() {
  var url = 'ws://198.199.72.139:1024/';
  createCanvas(windowWidth, windowHeight);
  ship = new Ship();
  for (var i = 0; i < 10; i++) {
    asteroids.push(new Asteroid());
  }
  socket = new WebSocket(url);
  socket.onopen = onopen;
  socket.onclose = onclose;
  socket.onerror = onerror;
  socket.onmessage = onmessage;

}

function onopen() {
  console.log('socketopen');
}

function onclose() {
  console.log('socketclose');
}

function onerror(error) {
  console.log('onerror', error);
}

function onmessage(event) {
  var message = event.data;
  console.log('onmessage', message);
  var trimmedString = trim(message); // get rid of all white space
  var myArray = split(trimmedString, ","); // splits the string into an array on commas

  userName = myArray[0];
  displayUserName = createP("Hey, " + userName + "! Beware of the asteroids!!!!!");
  displayUserName.style('color', '#ffffff');
  displayUserName.style('font-size', '32px');
  displayUserName.position(width / 2 - 250, 30);

  directionCommands = parseInt(myArray[1]); // get the second item in the array and turn into integer
  switch (directionCommands) {
    case 0: // Boost the ship
      ship.boosting(true);
      break;

    case 1: // Clockwise rotation
      ship.setRotation(0.1);
      break;

    case 2: // Counterclockwise rotation
      ship.setRotation(-0.1);
      break;

    case 3: // When users release buttons, stop rotation and boost
      ship.setRotation(0);
      ship.boosting(false);
      break;

    case 4: // Fire lasers
      lasers.push(new Laser(ship.pos, ship.heading));
      laserSound.play()
      break;

    default:

  }
}

function draw() {
  background(40, 48, 57);
  ship.render();
  ship.turn();
  ship.update();
  ship.edges();

  for (var i = 0; i < asteroids.length; i++) {
    if (ship.hits(asteroids[i])) {
      ship.setRotation(0);
      fill(255);
      textSize(32);
      text("You're Dead", width / 2 - 100, height / 2)
      location.reload();

    }
    asteroids[i].render();
    asteroids[i].update();
    asteroids[i].edges();
  }

  for (var i = lasers.length - 1; i >= 0; i--) {
    lasers[i].render();
    lasers[i].update();
    if (lasers[i].offscreen()) {
      lasers.splice(i, 1);
    } else {
      for (var j = asteroids.length - 1; j >= 0; j--) {
        if (lasers[i].hits(asteroids[j])) {
          if (asteroids[j].r > 10) {
            var newAsteroids = asteroids[j].breakup();
            asteroids = asteroids.concat(newAsteroids);
          }
          asteroids.splice(j, 1);
          lasers.splice(i, 1);
          break;
        }
      }
    }
  }
  console.log(lasers.length);
}

function restartTheGame() {
  location.reload();
}

function keyReleased() {
  ship.setRotation(0);
  ship.boosting(false);

}

function keyPressed() {
  if (key == " ") {
    lasers.push(new Laser(ship.pos, ship.heading));
  } else if (keyCode == RIGHT_ARROW) {
    ship.setRotation(0.1);
  } else if (keyCode == LEFT_ARROW) {
    ship.setRotation(-0.1);
  } else if (keyCode == UP_ARROW) {
    ship.boosting(true);
  }
}
