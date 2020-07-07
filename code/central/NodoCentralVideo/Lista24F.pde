
class Lista24F
{ 
  LinkedList<PImage> lista24;
  //LinkedList<PImage> lista24Min;
  LinkedList<Nodo> lista24N;
  int num;
  
  Lista24F(int n)
  { // creamos la lista con n Imagenes en negro o con error 404
    // las imágenes que vamos a guardar ya estan en el formato de envío, esto es en jpg
    num=n;
    lista24= new LinkedList();
    //lista24Min= new LinkedList();
    lista24N= new LinkedList();
    Nodo elementoInicial=null;
    String ip=null;
    int puerto=8088;
    PImage imagenInicial=null;
    PImage imagenInicialMin=null;
    for (int i = 0; i < n; i++) {
             
              //if (i<10) ip="192.168.0.20"+Integer.toString(i+2);
              //else ip="192.168.0.2"+Integer.toString(i+2);
              
              try{
              //elementoInicial= new Nodo(InetAddress.getByName(ip),9000);
              elementoInicial= new Nodo(InetAddress.getLocalHost(),puerto);
              imagenInicial=loadImage("error.jpeg");
              imagenInicialMin=loadImage("error.jpeg");
              puerto=puerto+1;}
              catch(Exception e){;}
              //lista24Min.add(imagenInicialMin);
              lista24.add(imagenInicial);
              //lista24Min.add(imagenInicialMin);
              lista24N.add(elementoInicial);
              
          }
  }
  /*
  ** lo que hacemos es dibujar para control de la aplicacion la lista de las imágenes
  **
  */
  void dibujar()
  { // recorremos la lista
    //con un bucle foreach
    int i=100;
    PImage img=null;
    Iterator<PImage> it = lista24.iterator();
    while (it.hasNext()) {
         img=it.next();
         //println("hola"+img);
         PImage copia=img.copy();
         copia.resize(78, 47);

         image(copia,i,66);
         i=i+78;
         //rectMode(CORNER);rect(x,y,80,220);
    }
         
}

void enviar(DatagramSocket ds)
  { // recorremos la lista
    
    int i=100;
    Iterator<PImage> it = lista24.iterator();
    Iterator<Nodo> it2 = lista24N.iterator();
    while ((it.hasNext())&&(it2.hasNext())) {
         Nodo nod=it2.next();
         PImage imagen=it.next();
         nod.enviar(ds,imagen);
         
    }
         
}

void insertar(PImage img)
{  
    lista24.addFirst(img); }

void borrar()
{ lista24.removeLast();}

/*

void insertarMin(PImage img)
{  
    lista24Min.addFirst(img); }

void borrarMin()
{ lista24Min.removeLast();}

*/
}

  
    
