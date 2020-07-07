import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;

/*NOTA version para enviar todo a Nodo Central
se plantea hacer otra donde se manda directamente
al nodoMonitor y el nodo central hace el control
*/

/*PROBLEMA con el algoritmo de compresión JPEG*/
/* Dependiendo de la maquina comprime mas o menos*/

// DE momento esta aplicación tendrá los siguientes
// ESTADOS
// ESTADO=0 reposo no hace nada
// ESTADO=1 envía las imágenes y recibe posibles 
// movimentos de cámara

// Puerto de envío
int clientPort = 8888; 
// ip donde esta el nodo central
String ip="192.168.0.106";

// el objeto para realizar el envío
DatagramSocket ds; 
// objeto para realizar la captura
Capture cam;

int estado;

void setup() {
  //size(1280,720);
  size(1280,720);
  // inicializamos el DatagramSocket, requiere try/catch
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
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
    cam = new Capture(this, 1280,720,cameras[0],5);
    //cam = new Capture(this, 800,450,cameras[0]);
    cam.start();   
  }
  
  // INICIALIZAMOS EL ESTADO 
  estado=1;
}

void captureEvent(Capture c) {
  if (estado==1)
  {   c.read();
      enviar(c);
   }
}

void draw() {
  image(cam,0,0);
}


// Envia una imagen sobre UDP

void enviar(PImage img) {

  // Es necesario un BufferedImage para codificar un JPG 
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_BYTE_GRAY);
  //BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

  // Se transfieren los pixeles desde la image al BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Para poder mandar los bytes mediante el protoloco UDP se plantean los siguientes Streams
  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

  // Volcamos la BufferedImage dengtro de un JPG y se pone en el BufferedOutputStream
  // Requiere try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Recuperamos byte array, que enviaremos via UDP!
  byte[] packet = baStream.toByteArray();

  // Enviamos el JPEG como un datagram
  println("Enviando datagrama con: " + packet.length + " bytes");
  try {
    ds.send(new DatagramPacket(packet,packet.length,InetAddress.getByName(ip),clientPort));
    println(" a la direccion:"+ip);
    //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getLocalHost(),clientPort));
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}
