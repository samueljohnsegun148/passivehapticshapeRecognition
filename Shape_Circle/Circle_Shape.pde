/**
 **********************************************************************************************************************
 * @file       sketch_2_Hello_Wall.pde
 * @author     Steve Ding, Colin Gallacher, sam
 * @version    V3.0.0
 * @date       08-January-2021
 * @brief      Wall haptic example with programmed physics for a haptic wall 
 **********************************************************************************************************************
 * @attention
 *
 *
 **********************************************************************************************************************
 */
 
  /* library imports *****************************************************************************************************/ 
import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
import java.util.HashMap;
import java.util.Map;
import processing.sound.*;
/* end library imports *************************************************************************************************/  


/* scheduler definition ************************************************************************************************/ 
private final ScheduledExecutorService scheduler      = Executors.newScheduledThreadPool(1);
/* end scheduler definition ********************************************************************************************/ 

public enum HaplyVersion {
  V2,
  V3,
  V3_1
}

final HaplyVersion version = HaplyVersion.V3_1;

/* device block definitions ********************************************************************************************/
Board             haplyBoard;
Device            widgetOne;
Mechanisms        pantograph;

byte              widgetOneID                         = 5;
int               CW                                  = 0;
int               CCW                                 = 1;
boolean           renderingForce                     = false;
/* end device block definition *****************************************************************************************/



/* framerate definition ************************************************************************************************/
long              baseFrameRate                       = 120;
/* end framerate definition ********************************************************************************************/ 



/* elements definition *************************************************************************************************/

/* Screen and world setup parameters */
float             pixelsPerMeter                      = 4000.0;
float             radsPerDegree                       = 0.01745;

/* pantagraph link parameters in meters */
float             l                                   = 0.07;
float             L                                   = 0.09;


/* end effector radius in meters */
float             rEE                                 = 0.006;

/* virtual wall parameter  */
float             kWall                               = 450;
PVector           fWall                               = new PVector(0, 0);
PVector           penWall                             = new PVector(0, 0);
PVector           posWall                             = new PVector(0.01, 0.10);



/* generic data for a 2DOF device */
/* joint space */
PVector           angles                              = new PVector(0, 0);
PVector           torques                             = new PVector(0, 0);

/* task space */
PVector           posEE                               = new PVector(0, 0);
PVector           fEE                                 = new PVector(0, 0); 

/* device graphical position */
PVector           deviceOrigin                        = new PVector(0, 0);

/* World boundaries reference */
final int         worldPixelWidth                     = 1000;
final int         worldPixelHeight                    = 650;


/* graphical elements */
PShape pGraph, joint, endEffector;
PShape wall;
PShape box;
/* end elements definition *********************************************************************************************/ 

/* Haptic lines and boxes design **********************************************/
PShape upperWall;
PShape lowerWall;
PShape leftWall;
PShape rightWall;

WhiteNoise noise;
PVector fTexture;



PShape cir1;
PShape cir2;
float R = 250;
float r = 80;

float cirCenX = 500;
float cirCenY = 300;
float penCircle = 0;
float penSmallCircle = 0;
float penBigCircle = 0;
//float r = screenX2Ava(cirCenX) - screenX2Ava(600);
PVector posCircle = new PVector (screenX2Ava(cirCenX), screenY2Ava(cirCenY));
PVector posEEToCircle;
float posEEToCircleMagnitude;
float angleEECircle;

/* Declare parameters */

//JSONArray boxArr = new JSONArray();


  
 
 




/* setup section *******************************************************************************************************/
void setup(){
   /* screen size definition */
   size(1000, 650);
  noise = new WhiteNoise(this);
  hapticWall();
  
  /* put setup code here, run once: */
 
 
cir1 = createShape(ELLIPSE, cirCenX, cirCenY, R, R);
cir2 = createShape(ELLIPSE, cirCenX, cirCenY, r, r);


 

 //print(boxArr);
  
  /* device setup */
  
  /**  
   * The board declaration needs to be changed depending on which USB serial port the Haply board is connected.
   * In the base example, a connection is setup to the first detected serial device, this parameter can be changed
   * to explicitly state the serial port will look like the following for different OS:
   *
   *      windows:      haplyBoard = new Board(this, "COM10", 0);
   *      linux:        haplyBoard = new Board(this, "/dev/ttyUSB0", 0);
   *      mac:          haplyBoard = new Board(this, "/dev/cu.usbmodem1411", 0);
   */ 
  haplyBoard          = new Board(this, Serial.list()[1], 0);
  //haplyBoard = new Board(this, "COM7", 0);
  
  widgetOne = new Device(widgetOneID, haplyBoard);
  if (version == HaplyVersion.V2) {
    pantograph = new Pantograph();
    widgetOne.set_mechanism(pantograph);
    widgetOne.add_actuator(1, CCW, 2);
    widgetOne.add_actuator(2, CW, 1);
    widgetOne.add_encoder(1, CCW, 241, 10752, 2);
    widgetOne.add_encoder(2, CW, -61, 10752, 1);
  } else if (version == HaplyVersion.V3 || version == HaplyVersion.V3_1) {
    pantograph = new Pantographv3();
    widgetOne.set_mechanism(pantograph);
    widgetOne.add_actuator(1, CCW, 2);
    widgetOne.add_actuator(2, CCW, 1);
    if (version == HaplyVersion.V3) {
      widgetOne.add_encoder(1, CCW, 97.23, 2048*2.5*1.0194*1.0154, 2);   //right in theory
      widgetOne.add_encoder(2, CCW, 82.77, 2048*2.5*1.0194, 1);    //left in theory
    } else {
      widgetOne.add_encoder(1, CCW, 168, 4880, 2);
      widgetOne.add_encoder(2, CCW, 12, 4880, 1); 

    }
  }
  widgetOne.device_set_parameters();
  
  
  
  
  
  
  pantograph          = new Pantograph();
  //pantograph          = new Pantographv3();
  
  widgetOne.set_mechanism(pantograph);
  
  widgetOne.add_actuator(1, CCW, 2);
  widgetOne.add_actuator(2, CW, 1);
 
  widgetOne.add_encoder(1, CCW, 241, 10752, 2);
  widgetOne.add_encoder(2, CW, -61, 10752, 1);
  
  // version3
  //widgetOne.add_encoder(1, CCW, 97.23, 2048*2.5*1.0194*1.0154, 2);   //right in theory
  //widgetOne.add_encoder(2, CCW, 82.77, 2048*2.5*1.0194, 1);    //left in theory
  
  //version3.1
  //widgetOne.add_encoder(1, CCW, 168, 4880, 2);
  //widgetOne.add_encoder(2, CCW, 12, 4880, 1); 
  
  widgetOne.device_set_parameters();
    
  
  /* visual elements setup */
  background(0);
  deviceOrigin.add(worldPixelWidth/2, 0);
  
  /* create pantagraph graphics */
  create_pantagraph();
  
  /* create wall graphics */
  wall = create_wall(posWall.x-0.2, posWall.y+rEE, posWall.x+0.2, posWall.y+rEE);
  wall.setStroke(color(0));
  
  
  
  /* setup framerate speed */
  frameRate(baseFrameRate);
  
  
  /* setup simulation thread to run at 1kHz */ 
  SimulationThread st = new SimulationThread();
  scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
     
   
   //image(imgUpper1, 120, 41);
   
   //image(imgterrain,  boxUpp1.startX, boxUpp1.startY);
  
}
/* end setup section ***************************************************************************************************/



/* draw section ********************************************************************************************************/
void draw(){
   
  
  /* put graphical code here, runs repeatedly at defined framerate in setup, else default at 60fps: */
  if(renderingForce == false){
   
    background(255); 
  
    
    update_animation(angles.x*radsPerDegree, angles.y*radsPerDegree, posEE.x, posEE.y);
    
    
    
    
  }
  
  
}
/* end draw section ****************************************************************************************************/



/* simulation section **************************************************************************************************/
class SimulationThread implements Runnable{
  
  public void run(){
    /* put haptic simulation code here, runs repeatedly at 1kHz as defined in setup */
    
    renderingForce = true;
    
    if(haplyBoard.data_available()){
      /* GET END-EFFECTOR STATE (TASK SPACE) */
      widgetOne.device_read_data();
    
      angles.set(widgetOne.get_device_angles()); 
      posEE.set(widgetOne.get_device_position(angles.array()));
      posEE.set(device_to_graphics(posEE)); 
     
    
      /* haptic wall force calculation */
      fWall.set(0, 0);
      
      
      
    
     float smallCircleRadius = screenY2Ava(r) * 0.5;
     float bigCircleRadius = screenY2Ava(R) * 0.5;
     float forceStrength = 2;
     penSmallCircle = calculateEECircleDistance(posEE.x, posEE.y, cirCenX, cirCenY) -  rEE - smallCircleRadius;
     angleEECircle = calculateEECircleAngle(posEE.x, posEE.y, cirCenX, cirCenY);
     
     if (penSmallCircle <= 0) {
        float forceLat = (float) (forceStrength * Math.cos(angleEECircle));
        float forceNorm = (float) (forceStrength * Math.sin(angleEECircle));
        penWall.set(forceLat, forceNorm);
        fWall = fWall.add(penWall); 
            
     }
     
    penBigCircle = calculateEECircleDistance(posEE.x, posEE.y, cirCenX, cirCenY) - bigCircleRadius;
    angleEECircle = calculateEECircleAngle(posEE.x, posEE.y, cirCenX, cirCenY);
     
     if (penBigCircle >= 0 ) {
        float forceLat = (float) (forceStrength * 1.5 * Math.cos(angleEECircle));
        float forceNorm = (float) (forceStrength * 1.5 * Math.sin(angleEECircle));
        penWall.set(forceLat, forceNorm);
        fWall = fWall.add(penWall.mult(-1)); 
          
     }
     
     if (penBigCircle <= 0 && penSmallCircle > 0) {
        containerShakingTexture(); //the experience if the texture is a fuction of vel instead of spatial period
        //gunEffectTexture();
        noise.play();
        noise.amp(0.005);
        noise.pan(map(posEE.x, screenX2Ava(cirCenX- (R*0.5)), screenX2Ava(cirCenX + (R*0.5)), 1, -1));
       fWall.add(fTexture.mult(-1));
      
           
     }
     
     

      fEE = (fWall.copy()).mult(-1);
      fEE.set(graphics_to_device(fEE));
      /* end haptic wall force calculation */
    }
    
    
    torques.set(widgetOne.set_device_torques(fEE.array()));
    widgetOne.device_write_torques();
  
  
    renderingForce = false;
    //noise.stop();
  }
}
/* end simulation section **********************************************************************************************/


/* helper functions section, place helper functions here ***************************************************************/
void create_pantagraph(){
  float lAni = pixelsPerMeter * l;
  float LAni = pixelsPerMeter * L;
  float rEEAni = pixelsPerMeter * rEE;
  
  pGraph = createShape();
  pGraph.beginShape();
  pGraph.fill(255);
  pGraph.stroke(0);
  pGraph.strokeWeight(2);
  
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.vertex(deviceOrigin.x, deviceOrigin.y);
  pGraph.endShape(CLOSE);
  
  joint = createShape(ELLIPSE, deviceOrigin.x, deviceOrigin.y, rEEAni, rEEAni);
  joint.setStroke(color(0));
  
  endEffector = createShape(ELLIPSE, deviceOrigin.x, deviceOrigin.y, 2*rEEAni, 2*rEEAni);
  endEffector.setStroke(color(0));
  strokeWeight(5);
  
}


PShape create_wall(float x1, float y1, float x2, float y2){
  x1 = pixelsPerMeter * x1;
  y1 = pixelsPerMeter * y1;
  x2 = pixelsPerMeter * x2;
  y2 = pixelsPerMeter * y2;
  
  return createShape(LINE, deviceOrigin.x + x1, deviceOrigin.y + y1, deviceOrigin.x + x2, deviceOrigin.y+y2);
}


void update_animation(float th1, float th2, float xE, float yE){
  background(255);

  float lAni = pixelsPerMeter * l;
  float LAni = pixelsPerMeter * L;
  
  xE = pixelsPerMeter * xE;
  yE = pixelsPerMeter * yE;
  
  th1 = 3.14 - th1;
  th2 = 3.14 - th2;
  
  pGraph.setVertex(1, deviceOrigin.x + lAni*cos(th1), deviceOrigin.y + lAni*sin(th1));
  pGraph.setVertex(3, deviceOrigin.x + lAni*cos(th2), deviceOrigin.y + lAni*sin(th2));
  pGraph.setVertex(2, deviceOrigin.x + xE, deviceOrigin.y + yE);
  
  shape(pGraph);
  shape(joint);
  //shape(wall);
  
  
  shape(cir1);
  shape(cir2);
 
  
  translate(xE, yE);
  shape(endEffector);
    
}


PVector device_to_graphics(PVector deviceFrame){
  return deviceFrame.set(-deviceFrame.x, deviceFrame.y);
}


PVector graphics_to_device(PVector graphicsFrame){
  return graphicsFrame.set(-graphicsFrame.x, graphicsFrame.y);
}



/* end helper functions section ****************************************************************************************/







  
 /* Calculate the distance between circle and the avatar as the avatar moves */
float calculateEECircleDistance (float x1, float y1, float x2, float y2) {
    x2 = screenX2Ava(x2);
    y2 = screenY2Ava(y2);
    float distance = (float) Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
    return distance;
   }
   
/* Calculate the angle between circle and the avatar as the avatar moves */
float calculateEECircleAngle (float x1, float y1, float x2, float y2) {
    x2 = screenX2Ava(x2);
    y2 = screenY2Ava(y2);
    float angle = (float) Math.atan2(y2 - y1, x2 - x1);
    return angle;
   }
 
 

    
 
   
   
  
      
  /* screen pixels to Avatar coordinates */
  
  float screenX2Ava (float x) {
   return (x - deviceOrigin.x)/pixelsPerMeter;
  }
  
  float screenY2Ava (float y) {
   return (y - deviceOrigin.y)/pixelsPerMeter;
  }
  
  
 /* Texture model */
 
 void rockyTexture (float y, float fNormal) {
        fTexture = new PVector(0,0);
        float ampli = 3;
       
        float mu = 0.9;
        float spacing = 100; // at 100 spacing, the rougness is coarse, this becomes smooth as spacing reduces, at 1000, rougness is smooth ( smooth, coarse roughness, moderate roughness. ampli 30, mu=0.1  
        float fFriction = -1 * mu * kWall * max(penWall.y, fNormal); // I noticed there is a texture gradient from the wall down waard....like uo going deeperinto the ocean
        fTexture.add(fFriction - fFriction * ampli * sin(2 * PI * posEE.x * spacing), 0); // bycle effect       
        //print("ftext", fTexture);
 }
 
 

 void gunEffectTexture() {
      fTexture = new PVector(0,0);
      float amp = 1.5; //default =1.5
      float stickingEffect = 0;
      float freq = 50;
      
      fTexture.set(amp * sin(2 * PI * 1/(posEE.x)), 0); //rocky surface, it was very fast with targent. also when combined with force constraint and at sample rate of MHz, you will generate grinding equipent expeirence
        //posEEL = posEE.x;
        //stickingEffect = (posEE.x - posEEL)*200;
         //fTexture.set(posEE.x * 100* sin(2 * PI * freq * posEE.x*100), 0); // undamped oscillation
         
      }
      
  void stickyTexture() {    
        fTexture = new PVector(0, 0);
        float ampli = 1.5;
        float freq = 50;
        
        // texture taking account of of x and y
        fTexture.add(ampli * sin(2 * PI * freq * posEE.x), ampli * sin(2 * PI * freq * posEE.y)); // with ampli set to 1.5, the texture felt sticky/muddy/gum like experience  + 
        
  }
  
  void containerShakingTexture () {
     fTexture = new PVector(0,0);
        
        float ampli = 0.5; //default is 1 and deafult ftexture y value is 0
        float spatialPeriod = 1;
        //posEELast.set(posEE);
        //surfaceDisp = posEE.x - posEELast.x;
        fTexture.set(ampli * sin (2 * PI * 1/posEE.x * spatialPeriod), ampli * cos (2 * PI * 1/posEE.x * spatialPeriod)); // container haptics effects;
        
  }
  
  void testTexture() {
        fTexture = new PVector(0,0);
        float ftext = 0;
        float ampli = 1.5;
        float spatialPeriod = 1;
        float p = 53; // p = 3, 31, 121
        //posEELast.set(posEE);
        //surfaceDisp = posEE.x - posEELast.x;
        //fTexture.set(ampli * sin (2 * PI * 121 * posEE.x), 0); // slightly rough;
        ftext = ampli * sin(2 * PI * p * posEE.x);
        fTexture.set(ampli * sin (2 * PI * 121 * posEE.x)* ftext, 0); // sticky effect
  }
  /* Define a rectangular wall */
  void hapticWall () {
   
     upperWall = createShape(LINE, 10, 0, width-10 , 0);
     upperWall.setStrokeWeight(10);
     upperWall.stroke(#006400);
     lowerWall = createShape(LINE, 10, height-10 , width-10 , height-10 );
     lowerWall.setStrokeWeight(10);
     
     leftWall = createShape(LINE, 10, 0, 10, height-10 );
     leftWall.setStrokeWeight(10);
     
     rightWall = createShape(LINE, width-10 , 0, width-10, height-10 );
     rightWall.setStrokeWeight(10);
    
      
  }
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
   
    
      
 
