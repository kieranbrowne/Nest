/*
LIVING, BREATHING - Generative Film
November 2013

Based on "Medusa" by Denis Hovart, licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
Work: http://openprocessing.org/visuals/?visualID= 25856  
License: 
http://creativecommons.org/licenses/by-sa/3.0/
http://creativecommons.org/licenses/GPL/2.0/
*/

float szr = 800 ; // bounds of movement.
boolean life = false ;
float scal = 3 ;
float circ = 1;
float spinplus=1 ;


// From Robert Penner's easing equations
static class Penner {
  // time, beginning position, change in position, and duration
  static float easeInOutExpo(float t, float b, float c, float d) {
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
    return c/2 * (-pow(2, -10 * --t) + 2) + b;
  }
};

class TentaclePart {
  PVector position;
  float width;
  float height;
  color clr;
};

class Tentacle {

  PVector position;
  float orientation;
  float angularVelocity;
  int nbParts;
  float compactness;
  ArrayList<TentaclePart> parts;

  Tentacle(PVector pos, int nb, float w, float h, float o, float c) {
    position = pos;
    nbParts = nb;
    float headWidth = w;
    float headHeight = h;
    compactness = c;
    orientation = o;
    angularVelocity = 0;
    parts = new ArrayList<TentaclePart>();

    for (int i = 0; i < nbParts; i++) {
      TentaclePart part = new TentaclePart();
      part.width = (nbParts-i) * headWidth / (float)nbParts;
      part.height = (nbParts-i) * headHeight / (float)nbParts;
      part.position = position.get();
      part.position.x += compactness * i * cos( orientation );
      part.position.y += compactness * i * sin( orientation );
      part.clr = color(0, 0, 255,255-i*5); /////////////////////////////  COLOUR!!!
      parts.add( part );
    }
  }

  void update() {
    PVector pos0 = parts.get(0).position;
    PVector pos1 = parts.get(1).position;
    pos0.set(position.get());
    pos1.x = pos0.x + ( compactness * cos( orientation ) );
    pos1.y = pos0.y + ( compactness * sin( orientation ) );
    for (int i = 2; i < nbParts; i++) {
      PVector currentPos = parts.get(i).position.get();
      PVector dist = PVector.sub( currentPos, parts.get(i-2).position.get() );
      float distmag = dist.mag();
      PVector pos = parts.get(i - 1).position.get();
      PVector move = PVector.mult(dist, compactness);
      move.div(distmag);
      pos.add(move);
      parts.get(i).position.set(pos);
    }
    fill(255) ;
  }

  void draw() {
    for (int i = nbParts - 1; i >= 0; i--) {
      TentaclePart part = parts.get(i);
      noStroke();
      fill(part.clr);
      ellipse(part.position.x, part.position.y, part.width, part.height);
      
    }
  }
  
};

class Creature {

  PVector position;
  float radX, radY;
  float orientation;

  color headClr;

  ArrayList<Tentacle> tentacles;
  int nbTentacles;
  int tentaclesLength;

  int moveTime;
  int moveDuration;
  PVector dest;
  PVector lastPos;
  float moveDistance;
  boolean reachedDest;
  float spin ;

  Creature(PVector pos, float rx, float ry, int nb, int l, float ts, float td) {

    position = pos;
    radX = rx;
    radY = ry;
    orientation = 0;
;

    nbTentacles = nb;
    tentaclesLength = l;
    tentacles = new ArrayList<Tentacle>();
    dest = new PVector(random(-1,1), random(-1,1));
    dest.mult(moveDistance);
    lastPos = position.get();
    moveDuration = 130;
    moveDistance = 00;
    reachedDest = true;
    moveTime = 0;

    
    for (int i = 0; i < nbTentacles; i++) {
      float tx = position.x + (cos(i * TWO_PI / nbTentacles) * radX/2);
      float ty = position.y + (sin(i * TWO_PI / nbTentacles) * radY/2);
      float tr = atan2(ty - position.y, tx - position.x);
      Tentacle tentacle = new Tentacle(new PVector(tx, ty), tentaclesLength, ts, ts, tr, td);
      tentacles.add(tentacle);
    }
  }

  void update() {
    spin = float(frameCount)/((7+float(frameCount)/200)-spinplus) ; //spin
    if(life==true){moveDistance = 460;}else{moveDistance = 0;}
    for (int i = 0; i < nbTentacles; i++) {
      Tentacle t = tentacles.get(i);
      t.position.x = position.x + (cos((spin+ i * TWO_PI / nbTentacles) + orientation) * radX/2);
      t.position.y = position.y + (sin((spin+ i * TWO_PI / nbTentacles) + orientation) * radY/2);
      t.orientation = atan2((t.position.y - position.y), (t.position.x - position.x));
      t.update();
    }

    if(reachedDest) {
      lastPos = position.get();
      dest = new PVector(random(-1,1), random(-1,1));
      dest.normalize();
      dest.mult(moveDistance);

      PVector nextPos = PVector.add(position, dest);
      float distFromCent = dist(nextPos.x,nextPos.y, 0,0) ;
      if(distFromCent > (height-100))
        dest.x = 0;

      if(distFromCent > (height-100))
        dest.y = -0;

      reachedDest = false;
      moveTime = 0;
    }
    else {
      position.x = Penner.easeInOutExpo(moveTime, lastPos.x, dest.x, moveDuration);
      position.y = Penner.easeInOutExpo(moveTime, lastPos.y, dest.y, moveDuration);
      moveTime++;
      if(moveTime >= moveDuration)
        reachedDest = true;
    }
    orientation += random(-3, 3) * radians(.1);
  }

  void draw() {
    fill(200);
    for(int i = 0; i < nbTentacles; i++)
      tentacles.get(i).draw();

    szr = 60;
    float rad, spd ;
    if(frameCount <=100){
      szr = 1000 - float(frameCount)*10 ;

    }else{
      szr = 10 + circ ;
    }
    if(life){ circ *=1.00002 ; spinplus *=1.0004 ;}
    spd = 200 + float(frameCount)/4 ;
    rad =(sin(1+float(frameCount)/spd)+0.0)*szr ;
    //if(frameCount <=100) ellipse(0,0,90,90) ;
    //if(frameCount >=100) ellipse(0,0,rad,rad) ;
   radY= rad ;
   radX= rad ;
  }
};

Creature c;
Creature d;
Creature e;
Creature f;
Creature g;
void setup() {
  colorMode(HSB);
  smooth();
  size(1920, 1080);
  //size(800,800) ;
  frameRate(25) ;
  c = new Creature( new PVector(0, 0), 30, 30, 9/*# of legs*/, 60/*leg pivots*/, 20/*leg thickness*/, 8/*spread size*/ );
  d = new Creature( new PVector(-height,0),30,30, 5, 40, 16, 8);
  e = new Creature( new PVector(height,0),30,30, 11, 50, 12, 4);
  f = new Creature( new PVector(-height,0),30,30, 9, 30, 8, 7);
  g = new Creature( new PVector(height,0),30,30, 7, 33, 19, 7);
}

void draw() {
  fill(0);
  rect(0,0,width,height);
  
  
  pushMatrix() ;
  
  translate(width/2,height/2) ;
  scal *= 0.9996 ;
  scale(scal) ;

  c.update();
  c.draw();

  if(life) {d.update(); d.draw() ;
  e.update(); e.draw() ;
  f.update(); f.draw() ;
  g.update(); g.draw() ;}
  println(frameCount) ;
  if(frameCount==15000) noLoop() ;

  popMatrix() ;
}
void mousePressed() {
  if (life == false) life = true ;
  println(life) ;
}
