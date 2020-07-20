import processing.video.*;

import javax.imageio.*;
import javax.imageio.stream.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;
import java.util.*;
import controlP5.*;



// cada nodo aranya tendrá su identificador
byte identificador=1;
// Puerto de recepción de datos de control, en este caso las imagenes
// que vienen de los nodos araña

int puertoRecepcion = 9050; 

// Puerto de envío de imágenes a los nodos pantalla
int puertoEnvio = 9991; 

// Puerto de envío de mensajes de control a todos los nodos
int puertoEnvioTodos = 9992; 

// direccion de esta máquina
String direccionIP="....";

// fichero donde estan los datos de los nodos
String fichNodosPantalla="nodosPantalla.csv";
String fichNodosTodos="nodosTodos.csv";
ListaNodos listaNodosPantalla, listaNodosTodos;


// el socket principal para enviar y recibir
DatagramSocket dsEnvio, dsRecepcion,dsEnvioTodos; 
Nodo nodoRecepcion;

PImage imagenActual;
byte [] imagenByte,imagenByte1;

// luego el fake será un video al final del todo


// Variables de estado de la aplicación
int estado;
// interfaz grafica para simular estados
ControlP5 cp5;



void setup() {

  size(1280, 720);
  // inicializamos el DatagramSocket para envío y recepcion
  try {  
    dsRecepcion = new DatagramSocket(puertoRecepcion);
    dsEnvio = new DatagramSocket(puertoEnvio);
    dsEnvioTodos = new DatagramSocket(puertoEnvioTodos);
    
  } 
  catch (SocketException e) { 
    e.printStackTrace();
  }
  
  //imagenByte=new byte[65000]; 
  imagenActual=loadImage("error_1.jpg");
  imagenByte=comprimir(imagenActual);
  // Inicializamos la lista para el envío alos nodos pantalla
  // vamos a añadirle 
  listaNodosPantalla= new ListaNodos(fichNodosPantalla, imagenByte, dsEnvio,12,2);
  // Inicializamos la lista para el envío a todos los nodos para control
  listaNodosTodos= new ListaNodos(fichNodosTodos, dsEnvioTodos);
  // creamos el nodo de recepción
  nodoRecepcion= new Nodo(dsRecepcion);
  // luego activar la visualizacion
  
  
  estado=0;
  //imagenByte=new byte[65000]; 
  //// inicilizamos la imagen inicial
  //for(int i=0; i<imagenByte.length;i++) { imagenByte[i]=0; }
  
  thread("recibirImagen");
  
  // definimos el elemento de la interfaz gráfica
  cp5 = new ControlP5(this);
  
  cp5.addTextfield("mensaje")
     .setPosition(250,500)
     .setSize(200,40)
     .setFont(createFont("arial",20))
     .setAutoClear(true)
     ;
       
  
  
}


void draw() {

  // realizamos el envío a todos los nodos Pantalla
  background(0);
  if (estado==1)
  { 
    //Primero recuperamos la imagen y luego la mandamos
    
   
    //byte [] imagenByte=nodoRecepcion.recibir();
    //// guardarlo en la lista y borrar el último
    //listaNodosPantalla.borrarImagenByte();
    //listaNodosPantalla.insertarImagenByte(imagenByte);
    listaNodosPantalla.enviarImagenByte();
    //listaNodosPantalla.dibujarListaImagenByte();
    
    text(" enviando datos ....", 640, 100);
    //println("tamanyo de la imagen en Central: "+imagenByte.length);
    
  }
   //image(imagenActual,0,0);
   cp5.get(Textfield.class,"mensaje").setVisible(true);
   
}

void recibirImagen() {
  while (true)
  {
    if (estado==1)

    {
      byte [] imagenByte=nodoRecepcion.recibir();
      // guardarlo en la lista y borrar el último
      listaNodosPantalla.borrarImagenByte();
      listaNodosPantalla.insertarImagenByte(imagenByte);
      
    }
    else delay(1000);
  }
}
PImage descomprimir(byte [] data)
{ 
  // creamos una imagen vacia
  PImage imagen = createImage(1280, 720, RGB);
  // leemos los datos dentro de ByteArrayInputStream
  ByteArrayInputStream bais = new ByteArrayInputStream(data); 
  // tendremos que desomprimir la imagen jpg y ponerla en unaPImage 
  imagen.loadPixels();
  try {
    // Hacemos un BufferedImage out para recibir los bytes
    BufferedImage img = ImageIO.read(bais);
    // ponemos los pixeles en  PImage
    img.getRGB(0, 0, imagen.width, imagen.height, imagen.pixels, 0, imagen.width);
  } 
  catch (Exception e) { 
    e.printStackTrace();
  }
  // actualizamos la PImage
  imagen.updatePixels();
  return imagen;
}
public void mensaje(String msj) {
  // envio mensaje de control
  // lo que tendremos que hacer es obtener los dos datos
  // y realizar el envío correspondiente
  // enviamos a la lista
  println(msj);
  byte[] mensaje=analizar(msj);
  listaNodosTodos.enviarByte(mensaje);
}
byte [] analizar(String msj)
{   
    byte[] m=new byte[3];
    // en realidad la idea es sencilla pero por conversiones
    // de tipo hay que montar todo este lio
    int x1=msj.charAt(0)-48;
    int x2=msj.charAt(1)-48;
    m[0]=(byte)x1;
    m[1]=(byte)x2;
    //m[1]=(byte)msj.charAt(1);
    //m[0]=(byte)msj.charAt(0);
    //m[1]=(byte)msj.charAt(1);
    println(m[0]+","+m[1]);
    return m;
}

 //De momento cambiamos el estado de forma manual sobre todo para que de tiempo a 
 //que se realice la primera captura
void keyPressed() {
  if (key == 'a') {
    cambiarEstado(0);
  }
  if (key == 'b') {
    cambiarEstado(1);
  } 
  if (key == 'c') {
    cambiarEstado(2);
  } 


  //println("estado="+estado);
}

void cambiarEstado(int nuevoEstado)
{
  estado=nuevoEstado;
  println("estadoEstado="+estado);
} // fin cambiar estado

private byte [] comprimir(PImage imagen)
  { 
    byte[] packet=null;


    BufferedImage bimg = new BufferedImage(imagen.width, imagen.height, BufferedImage.TYPE_BYTE_GRAY);
    //BufferedImage bimg = new BufferedImage(imagen.width, imagen.height, BufferedImage.TYPE_INT_RGB);

    // transferimos los pixeles al bufferImagen
    imagen.loadPixels();
    bimg.setRGB( 0, 0, imagen.width, imagen.height, imagen.pixels, 0, imagen.width);
    //ColorConvertOp ccop = new ColorConvertOp(ColorSpace.getInstance(ColorSpace.CS_GRAY), null);
    //BufferedImage bimg = ccop.filter(bimg1, null);
    // Para la comunicacion UDP tenemos que mandar bytes

    ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
    BufferedOutputStream bos    = new BufferedOutputStream(baStream);

    // Ponemos el BufferedImage dentro de un JPG y lo ponemos en el BufferedOutputStream

    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }

    // recuperamos byte array, que enviaremos via UDP!
    packet = baStream.toByteArray();
    //println("el numero de elementos es: "+packet.length);
    return packet;
  }
