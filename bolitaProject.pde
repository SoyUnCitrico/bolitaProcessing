BolitaCluster cluster;
FlowField campo;

PImage img;
boolean debugCampo = false;
boolean campoVisible = false;
boolean fotoVisible = false;

void setup() {
  size(600,600);
  //fullScreen();
  background(0);
  img = loadImage("emmeSqr.jpg");
  img.resize(width,height);
  //Inicializacion del campo de vectores con e tamaño de la cuadricula
  //y la forma de la imagen que le estoy pasando;
  //campo = new FlowField(5,img);
  campo = new FlowField(20);
  //Inicializacion del Cluster de vehiculos que van a atravesar ese campo
  cluster = new BolitaCluster(5);
}

void draw() {
  //background(0);
  
  if(fotoVisible)
    image(img,0,0);
  
  if(campoVisible)
    campo.mostrarCampo();
  
  //cluster.arrivarMouse();
  
  //cluster.deambularCluster("REVERSE_Y");
  
  cluster.atravesarCampo(campo,"OTHERSIDE");
  
  //ArrayList<Bolita> otras = cluster.getBolitas();
  //cluster.manadaCluster(otras,"OTHERSIDE");
  
}

void keyPressed() {
  if(keyCode == 32) campo.initNoise();
  switch(key) {
    case 'w':
      cluster.debugDeambular();
      break;
    case 'f':
      campoVisible = !campoVisible;
      break;
    case 'p':
      fotoVisible = !fotoVisible;
      break;
    case 'n':
      cluster.crecer();   
      break;
    case 'v':
      cluster.cambiarLifeMode();
      
      break;
      
    default:
      print(String.format("La tecla %s ha sido presionada\n", keyCode));
      print("No hay accion\n");
      break;
    }
}
