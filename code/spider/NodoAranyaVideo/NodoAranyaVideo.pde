import processing.video.*;

import javax.imageio.*;
import javax.imageio.stream.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;
import java.util.*;

import java.awt.color.ColorSpace;
import java.awt.image.ColorConvertOp;


// DE momento esta aplicación tendrá los siguientes
// ESTADOS:
// ----ESTADO=0 reposo no hace nada
// ----ESTADO=1 envía las imágenes y recibe posibles 
// movimentos de cámara y control
// ----ESTADO=2 envía fusion fake y recibe posibles movimientos de cámara y control

// el movimiento de cámara lo veremos de momento solo esos estados, pero puede
// ser independiente de la araña
// los mensajes que recibe para los cambios de estados
// son X0,X1,X2, donde X es el identificador de la camara
// empiezan en el numero 2, 3,4,5, el identificador 1 son las pantallas

// cada nodo aranya tendrá su identificador
// la numeracion empieza en 2
// DATOS PARA FICHERO DE CONFIGURACION
byte identificador=2;
// Puerto de recepción de datos de control
int puertoRecepcion = 9990; 

// Puerto de envío de imágenes
int puertoEnvio = 9999; 

// direccion de esta máquina
String direccionIP="....";

// fichero donde estan los datos de los nodos
// Aqui es donde envía realmente se ha dejado para los nodos
// aranya igual que en el nodoCentral por comodidad, pero la lista 
// esta formada por solo el nodo central, mas adelante se depurará
String fichNodos="nodoCentral.csv";

// FIN DE DATOS FICHERO DE CONFIGURACION
ListaNodosPantalla listaNodos;


// el socket principal para enviar y recibir
DatagramSocket dsEnvio, dsRecepcion; 
Nodo nodoRecepcion;
// objeto para realizar la captura
Capture cam;
PImage imagenActual;
// luego el fake será un video al final del todo
PImage fake;

// Variables de estado de la aplicación
int estado;

void setup() {

  size(1280, 720);

  // inicializamos el DatagramSocket para envío y recepcion
  try {  
    dsEnvio = new DatagramSocket(puertoEnvio);
    dsRecepcion = new DatagramSocket(puertoRecepcion);
  } 
  catch (SocketException e) { 
    e.printStackTrace();
  }
  // Inicializamos la lista para el envío
  listaNodos= new ListaNodosPantalla(fichNodos, dsEnvio);
  // creamos el nodo de recepción
  nodoRecepcion= new Nodo(dsRecepcion);

  imagenActual=loadImage("error.jpeg");
  fake=loadImage("error.jpeg");

  // Inicializamos la  camara
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("No hay camaras disponibles para captura");
    exit();
  } else {
    println("Camaras disponibles:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }






    // Inicializamos la captura con la numero 6 que 
    // es 1280x720 a 8 fps
    cam = new Capture(this, cameras[6]);
    //cam = new Capture(this, 1280, 720, cameras[0], 5);
    //cam = new Capture(this, 800,450,cameras[0]);
    cam.start();

    //lanzamos el hilo para recibir mensajes de control
    thread("recibirControl");
  }

  // INICIALIZAMOS EL ESTADO 
  estado=0;
  frameRate(1);

  // tendremos un hilo solo para recibir las órdenes del nodoCentral
}

//void captureEvent(Capture c) {
//  if (estado==1) 
//  { 
//    c.read();
//    imagenActual=c;
//  }
//}
void draw() {
  // realizamos el envío a todos los nodos Pantalla
  background(0);
  if ((estado==1)||(estado==2))
  { 
    if (cam.available() == true) {  
      cam.read(); 
      imagenActual=cam;
    }
    // mandamos la nueva imagen a todos los nodosPantalla
    if (estado==2) 
    {  // fusionamos la imagen actual con el fake

      imagenActual.blend(fake, 0, 0, fake.width, fake.height, 0, 0, imagenActual.width, imagenActual.height, MULTIPLY) ;
    }
    listaNodos.enviarImagen(imagenActual);

    // visualizamos la imagen
    image(imagenActual, 0, 0);
  }
}

void recibirControl() {
  byte [] buffer2= new byte[100];
  //while (!(estado==-1))
  while (true)
  {
    // Esta recepción siempre esta activa
    buffer2=nodoRecepcion.recibir();
    if (buffer2[0]== identificador) cambiarEstado(buffer2[1]);
  }
}

void cambiarEstado(int nuevoEstado)
{
  estado=nuevoEstado;
  println("estadoEstado="+estado);
} // fin cambiar estado





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


  //println("estado="+estado);
}
