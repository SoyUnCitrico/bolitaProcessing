BolitaCluster cluster;
FlowField campo;

PImage img;
boolean debugCampo = false;
boolean campoVisible = false;
boolean fotoVisible = false;

void setup() {
  size(600,600);
  background(0);
  img = loadImage("emme2.jpg");
  img.resize(width,height);
  //Inicializacion del campo de vectores con e tamaño de la cuadricula
  //y la forma de la imagen que le estoy pasando;
  campo = new FlowField(5,img);
  //Inicializacion del Cluster de vehiculos que van a atravesar ese campo
  cluster = new BolitaCluster(5);
}

void draw() {
  background(0);
  
  if(fotoVisible)
    image(img,0,0);
  
  if(campoVisible)
    campo.mostrarCampo();
  
  //cluster.arrivarMouse();
  //cluster.deambularCluster("REVERSE_X");
  cluster.atravesarCampo(campo,"REVERSE_X");
}

//void mousePressed() {
//  cluster.crecer();
//}

void keyPressed() {
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
    default:
      print(String.format("La tecla %s ha sido presionada\n", key));
      print("No hay accion\n");
      break;
    }
}
