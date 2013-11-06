/*
TOWARD NOTHING - Generative Film
November 2013

Based on "Spiral Galaxy" by Philippe Guglielmetti, licensed under Creative Commons Attribution-Share Alike 3.0 and GNU GPL license.
Work: http://openprocessing.org/visuals/?visualID= 699  
License: 
http://creativecommons.org/licenses/by-sa/3.0/
http://creativecommons.org/licenses/GPL/2.0/
*/

PImage frame;
int count = 1 ;
float pi=4*atan(1);
 
int stars=15000; // only ...
int Rmax=600; // galaxy radius
float speed=0.02;  // rotation speed
 
// stars follow elliptic orbits around the center
float eratio=1.0; // ellipse ratio
float etwist=12.0/Rmax; // twisting factor (orbit axes depend on radius)
 
float []angle=new float[stars];
float []radius=new float[stars];
 
float cx; float cy; //center
 
color []col=new color[stars];

float t1 = 0 ; float t2 = 0 ;
float tt = 0 ; // time taken
 
void setup(){
  frame = loadImage("frame.png") ;
  size(1920, 1080);
  smooth() ;
  background(0);
  speed=speed/frameRate;
 
  // begin in the center
  cx = width/2;
  cy = height/2;
  // itit stars
  for (int i=0; i< stars; i++){
    angle[i]= random(0,2*pi);
    radius[i]=random(1,Rmax);
    col[i]= color(random(100,255),random(50,200)) ;
  }

}
 
void draw(){
  
  fill(0,40);
  rect(0,0,width,height);
  
  noStroke();
  for (int i =0; i< stars-frameCount; i++){
    float r=radius[i];
    float a=angle[i]+speed; // increment angle
    angle[i]=a;
    float x = r*sin(a);
    float y= r*eratio*cos(a);
    float b=r*etwist;
    float s=sin(b);
    float c=cos(b);
    fill(col[i]);
    ellipse(cx+s*x+c*y,cy+c*x-s*y,2,2);
  }
  image(frame,0,0,width,height) ;
  count++ ;
  eratio=eratio*1.0002;
  etwist=etwist*1.0002;
  eratio -= float(frameCount)/2000000000 ;
  etwist -= float(frameCount)/200000000 ;
  speed -= float(frameCount)/200000000 ;
  println("eratio="+eratio+" etwist="+etwist);
  renderStats() ;
  noStroke() ;
  fill(0) ;
}
void renderStats(){
  t1 = millis()/1000 ;
  tt = (t1-t2) ; // calculate approx time taken
  t2 = millis()/1000 ;
  println("render took " + round(tt) + " seconds") ;
  println(ceil(tt*(15000-frameCount)/60) + " minutes remaining") ;
  
}
