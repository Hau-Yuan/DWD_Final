function Asteroid(pos, r) {
  if (pos) {
    this.pos = pos.copy();
  } else {
    this.pos = createVector(random(width), random(height));
  }

  if (r) {
    this.r = r * 0.5
  } else {
    this.r = random(20, 70);
  }
  this.vel = p5.Vector.random2D();
  this.total = floor(random(7, 20));
  this.offset = [];
  for (var i = 0; i < this.total; i++) {
    this.offset[i] = random(-this.r * 0.5, this.r * 0.5);
  }

  this.update = function() {
    this.pos.add(this.vel);
  }

  this.render = function() {
    push();
    translate(this.pos.x, this.pos.y);
    stroke(255);
    strokeWeight(2);
    noFill();
    beginShape();
    for (var i = 0; i < this.total; i++) {
      var angle = map(i, 0, this.total, 0, TWO_PI);
      var distance = this.r + this.offset[i];
      var x = distance * cos(angle);
      var y = distance * sin(angle);
      vertex(x, y);
    }
    endShape(CLOSE);
    pop();
  }
  this.breakup = function() {
    var newA = [];
    newA[0] = new Asteroid(this.pos, this.r);
    newA[1] = new Asteroid(this.pos, this.r);
    return newA;
  }
  this.edges = function() {
    if (this.pos.x > width + this.r) {
      this.pos.x = -this.r;
    } else if (this.pos.x < -this.r) {
      this.pos.x = width + this.r;
    }
    if (this.pos.y > height + this.r) {
      this.pos.y = -this.r;
    } else if (this.pos.y < -this.r) {
      this.pos.y = height + this.r;
    }
  }
}
