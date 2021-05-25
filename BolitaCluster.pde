import java.util.ArrayList;
import java.util.Iterator;

class BolitaCluster{
  ArrayList<Bolita> cluster = new ArrayList<Bolita>();
  int numElementos;
  
  BolitaCluster(int numBolitas) {
    numElementos = numBolitas;
    for(int i = 0; i < numBolitas; i++) {
      cluster.add(new Bolita(i));
      
    }
  }
  
  void seguirMouse() {
    //for(int i = 0; i < cluster.size(); i++) {
    //  Bolita b = cluster.get(i);
    //  b.vivir();
    //}    
    
    PVector mousePosition = new PVector(mouseX,mouseY); 
    Iterator<Bolita> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      Bolita b = it.next();
      b.seguirTarget(mousePosition);
      if (b.estaMuerto()) {
         it.remove();
         String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
         print(logOut);
      }
    }
  }
  
  void arrivarMouse() {
    PVector mousePosition = new PVector(mouseX,mouseY); 
    Iterator<Bolita> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      Bolita b = it.next();
      //b.buscarTarget(mousePosition);
      b.arrivarTarget(mousePosition,50.0,"OTHERSIDE");
 
      if (b.estaMuerto()) {
         it.remove();
         String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
         print(logOut);
      }
    }
  }
  
  void deambularCluster(String typeBoundaries) {
    Iterator<Bolita> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      Bolita b = it.next();
      b.pasear(typeBoundaries);
      
      if (b.estaMuerto()) {
         it.remove();
         String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
         print(logOut);
      }
    }
  }
  
  void atravesarCampo(FlowField campo, String typeBoundaries) {
    Iterator<Bolita> it = cluster.iterator();
    //Using an Iterator object instead of counting with int i
    while (it.hasNext()) {
      Bolita b = it.next();
      b.seguirCampo(campo,typeBoundaries);
      
      if (b.estaMuerto()) {
         it.remove();
         String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
         print(logOut);
      }
    }
  }
  
  void debugDeambular() {
    for(int i = 0; i < cluster.size(); i++) {
      Bolita b = cluster.get(i);
      b.toogleDebug();    
    }  
  }
  
  void crecer() {
    cluster.add(new Bolita(cluster.size()));
    String logOut = String.format("Bolitas en el cluster: %d\n", cluster.size());
    print(logOut);
  }
  
}
