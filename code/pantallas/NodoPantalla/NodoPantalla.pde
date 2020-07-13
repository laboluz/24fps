import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;

// posibles datos para fichero de configuracion
// todos los nodos pantalla tienen el identicador 1
int identificador=1;

// puerto para recibir
int port1 = 9000; 
int port2 = 9001; 
int port3 = 9990; 

String ipLocal="127.0.0.1";
// fin posibles datos

DatagramSocket ds1, ds2, dsRecepcion; 
Nodo nodoPantalla1, nodoPantalla2, nodoRecepcion;

// el byte para realizar la lectura
byte[] buffer1 = new byte[65000];
byte[] buffer2 = new byte[65000]; 
// la imagen a visualizar
PImage imagen1, imagen2;

// estado de la aplicación
int estado=1;
Cronometro crono;
//MENSAJES QUE LE LLEGAN QUE TIENE QUE GESTIONAR
// 10,11,12,13,14,15,16, donde:
// 10-dejar de visualizar
// 11-visualizar imagenes
// 12-ruleta a camara_1
// 13- ruleta a camara_2
// 14- ruleta a camara_3
// y asi sucesivamente

void setup() {

  size(2560, 720);
  //fullScreen();

  // creamos el socket para recibir a la imagen 1 y a la 2
  try { 
    ds1 = new DatagramSocket(port1);
    ds2 = new DatagramSocket(port2);
    dsRecepcion = new DatagramSocket(port3);
  } 
  catch (SocketException e) {
    e.printStackTrace();
  } 

  // realmente nunca va a enviar nada es solo para recibir
  nodoPantalla1=new Nodo(ipLocal, 9000, ds1);
  nodoPantalla2=new Nodo(ipLocal, 9001, ds2);
  // creamos el nodo de recepción
  nodoRecepcion= new Nodo(dsRecepcion);

  // creamos dos imagenes vacías
  imagen1 = createImage(1280, 720, RGB);
  imagen2 = createImage(1280, 720, RGB);
  crono=new Cronometro();

  // creamos dos hilos de ejecución independientes para 
  // realizar la recepción de la imágenes

  thread("recibirImagen1");
  thread("recibirImagen2");
  //lanzamos el hilo para recibir mensajes de control
  thread("recibirControl");
}

void draw() {

  background(0);
  if (estado==0) { 
    text("INICIOOOOO", 640, 360);
  }
  else if (estado==1)
  { // lo que hacemos es dibujar las dos imágenes
    image(imagen1, 0, 0);
    image(imagen2, 1280, 0);
    
   
  } else if (estado==2) { 
    // en vez de este texto debera salir
    text("RULETAAAAAA_CAMARA_1", 640, 360);
    // comprobamos el cambio de estado
    if (crono.end()) cambiarEstado(1);
  } else if (estado==3) { 

    text("RULETAAAAAA_CAMARA_2", 640, 360);
    // comprobamos el cambio de estado
    if (crono.end()) cambiarEstado(1);
  } else if (estado==4) { 

    text("RULETAAAAAA_CAMARA_3", 640, 360);
    // comprobamos el cambio de estado
    if (crono.end()) cambiarEstado(1);
  }
}

void recibirControl() {
  byte [] buffer2= new byte[10];
  while (true)
  {
    // Esta recepción siempre esta activa
    buffer2=nodoRecepcion.recibir();
    // si el mensaje es para los nodos pantalla proponemos el cambio de estado
    if (buffer2[0]== 1) cambiarEstado(buffer2[1]);
  }
}

void cambiarEstado(int nuevoEstado)
{
  //ESTADO==0
  if (estado==0) 
  { // si estamos el estado =0 y llega un 1 pasamos al estado=1
    if (nuevoEstado==1) estado=1;
    // si estamos en el estado =0 y llega un 1 pasamos al estado=2
    else if (nuevoEstado>=2) 
    {     
      estado=nuevoEstado;
      // arrancamos el crono por 5 segundos de momento
      crono.start(5000);
    }
  }//ESTADO==1
  else if (estado==1) 
  {
    if (nuevoEstado==0) estado=0;
    else if (nuevoEstado>=2) 
    { 
      estado=nuevoEstado;
      // arrancamos el crono por 5 segundos de momento
      crono.start(5000);
    }
  }//ESTADO==2
  else if (estado>=2) 
  {
    if (nuevoEstado==0) estado=0;
    else if (nuevoEstado==1) 
    { 
      crono.stop();
      crono.start(50000);
      estado=1;
    } else if (nuevoEstado>=2) 
    { 
      estado=nuevoEstado;
      // arrancamos el crono por 5 segundos de momento
      crono.start(5000);
    }
  }
  println("estadoEstado="+estado);
} // fin cambiar estado



void recibirImagen1() {
  while (true)
  {
    if (estado==1)
    {
      buffer1=nodoPantalla1.recibir();
      // tendremos que descomprimir la imagen
      imagen1=descomprimir(buffer1);
      
      
    }
    else delay(1000);
  }
}
void recibirImagen2() {
  while (true)
  {
    if (estado==1)

    {
      buffer2=nodoPantalla2.recibir();
      // tendremos que descomprimir la imagen
      imagen2=descomprimir(buffer2);
      
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



// De momento cambiamos el estado de forma manual sobre todo para que de tiempo a 
// que se realice la primera captura
void keyPressed() {
  if (key == '1') {
    cambiarEstado(1);
  }
  if (key == '0') {
    cambiarEstado(0);
  } 
  if (key == '2') {
    cambiarEstado(2);
  }
  if (key == '3') {
    cambiarEstado(3);
  } 
  if (key == '4') {
    cambiarEstado(4);
  } 


  //println("estado="+estado);
}
