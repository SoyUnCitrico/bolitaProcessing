class Bolita{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  
  int id;  
  float life;
  float damage;
  float maxSpeed;
  float maxForce;
  float wanderTheta;
  
  int diameter;
  color skin;
  color originalColor;
  boolean isDebugging;
  
  ////////////////  CONSTRUCTORES  //////////////////////
  
  Bolita(int identifier) {
    initBolita(identifier);
  }
  
  Bolita(int identifier, PVector pos) {
    initBolita(identifier);
    setPosition(pos);
  }
  
  void initBolita(int identifier) {
    position = new PVector(random(width),random(height));
    velocity = new PVector();
    acceleration = new PVector();
    
    id = identifier;
    life = 100;
    damage = .1;
    maxSpeed = 4;
    maxForce = 0.1;
    
    diameter = 16;
    skin = color(random(255),random(255),random(255));
    originalColor = skin;
    isDebugging = false;
  }
  
  ///////////////////  API  ////////////////////////
  
  void seguirTarget(PVector target) {
    buscar(target);
    actualizar();
    checkLimits("REVERSE_XY");
    vivir();
    dibujar();
  }
  
  void arrivarTarget(PVector target, float targetRadius, String typeBoundaries) {
    arrivar(target,targetRadius);
    actualizar();
    checkLimits(typeBoundaries);
    vivir();
    dibujar();
  }
  
  void pasear(String typeBoundaries) {
    wander();
    actualizar();
    checkLimits(typeBoundaries);
    vivir();
    dibujar();
  }
  
  void seguirCampo(FlowField campo, String typeBoundaries) {
    followField(campo);
    actualizar();
    checkLimits(typeBoundaries);
    vivir();
    dibujar();
 
  }
  
  ///////////////////  MÉTODOS  ////////////////////////
  void dibujar() {
    float theta = velocity.heading() + PI/2;
    pushMatrix();
    
    ////Bolitas 
    //noStroke();
    //fill(skin);
    //ellipse(position.x,position.y,diameter/2,diameter/2);
    
    //Vehiculo
    fill(skin);
    noStroke();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -diameter);
    vertex(-diameter/2, diameter);
    vertex(diameter/2, diameter);
    endShape(CLOSE);
    
    popMatrix();
    
  }
  
  void drawWander(PVector position, PVector circle, PVector target, float rad) {
    pushMatrix();
    stroke(0);
    fill(255);
    ellipseMode(CENTER);
    ellipse(circle.x,circle.y,rad*2,rad*2);
    ellipse(target.x,target.y,4,4);
    line(position.x,position.y,circle.x,circle.y);
    line(circle.x,circle.y,target.x,target.y);
    popMatrix();
  }
  
  void buscar(PVector objetivo) {
    PVector newPos = PVector.sub(objetivo, position).normalize().mult(maxSpeed);
    PVector newDir = PVector.sub(newPos,velocity).limit(maxForce);
    aplicarFuerza(newDir);
  }
  
  void arrivar(PVector objetivo, float distance) {
    PVector newPos = PVector.sub(objetivo, position);
 
    //The distance is the magnitude of the vector pointing from location to target.
    float d = newPos.mag();
    newPos.normalize();
    //If we are closer than 100 pixels...
    if (d < distance) {
    //...set the magnitude according to how close we are.
      float m = map(d,0,distance,0,maxSpeed);
      newPos.mult(m);
    } else {
    //Otherwise, proceed at maximum speed.
      newPos.mult(maxSpeed);
    }
 
    //The usual steering = desired - velocity
    PVector newDir = PVector.sub(newPos,velocity).limit(maxForce);
    aplicarFuerza(newDir);
    
  }
  
  void wander(){
    float wanderR = 25;         // Radius for our "wander circle"
    float wanderD = 80;         // Distance for our "wander circle"
    float change = 0.3;
    wanderTheta += random(-change,change);     // Randomly change wander theta

    // Now we have to calculate the new position to steer towards on the wander circle
    PVector circlepos = velocity.copy();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(position);               // Make it relative to boid's position

    float h = velocity.heading();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wanderTheta+h),wanderR*sin(wanderTheta+h));
    PVector target = PVector.add(circlepos,circleOffSet);
    buscar(target);
    //print("\n&d is debugging?\n R: %x",id,isDebugging);
    if(isDebugging)
      drawWander(position,circlepos,target,wanderR);
  }
  
   void followField(FlowField campo) {
    PVector desired = campo.lookup(position);
    desired.mult(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce); 
    aplicarFuerza(steer);
  }
  
  void actualizar() {
    velocity.add(acceleration).limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void aplicarFuerza(PVector fuerza) {
    acceleration.add(fuerza);
  }
  
  void vivir() {
    quitarVida();
    mapLifeToAlpha();
  }
 
  void quitarVida() {
    life -= damage;
  }
  
  void toogleDebug() {
    isDebugging = !isDebugging;
  }
  void aumentarVida(float health) {
    life += health;
  }
  
  void mapLifeToColor() {
   float r = red(originalColor);
   float g = green(originalColor);
   float b = blue(originalColor);
   
   float newR = map(life,0,100,0,r);
   float newG = map(life,0,100,0,g);
   float newB = map(life,0,100,0,b);
   
   setColor(color(newR,newG,newB));
  }
  
  void mapLifeToAlpha() {
   float a = alpha(originalColor);
   float r = red(originalColor);
   float g = green(originalColor);
   float b = blue(originalColor);
   float newAlpha = map(life,0,100,0,a);
   setColor(color(r,g,b,newAlpha));
  }
  
  void checkLimits(String type) {
    type.toUpperCase();
    switch(type) {
      case "OTHERSIDE":
        if(position.x > width) {
          position.x = 0 + diameter/2;
        }
        if(position.x < 0) {
          position.x = width - diameter/2;
        }
        if(position.y > height) {
          position.y = 0 + diameter/2;
        }
        if(position.y < 0) {
          position.y = height - diameter/2;
        }
        break;
      case "REVERSE_X":
        if(position.x > width || position.x < 0){
          velocity.x *= -1;
        }
        if(position.y > height) {
          position.y = 0 + diameter/2;
        }
        if(position.y < 0) {
          position.y = height - diameter/2;
        }
        break;
      case "REVERSE_Y":
        if(position.x > width) {
          position.x = 0 + diameter/2;
        }
        if(position.x < 0) {
          position.x = width - diameter/2;
        }
        if(position.y > width || position.y < 0){
          velocity.y *= -1;
        }
        break;
      case "REVERSE_XY":
        if(position.x > width || position.x < 0){
          velocity.x *= -1;
        }
        if(position.y > width || position.y < 0){
          velocity.y *= -1;
        }
        break;
      
      default:
        print("No limits\n");
        break;
    }
  }
  
  boolean estaMuerto(){
    if(life < 0.0) {
      String logOut = String.format("La bolita %d ha muerto\n", id);
      print(logOut);
      return true;
    } else {
      return false;
    }
  }
  
  //////////////  GETTERS // SETTERS /////////////////////////
  
  void setDiameter(int d) {
    diameter = d;
  }
  
  void setDamage(float d) {
    damage = d;
  }
 
  void setColor(color c) {
    skin = c;
  }
  
  void setPosition(PVector p) {
    position = p.copy();
  }
  
  float getLife() {
    return life;
  }
  
 
}
