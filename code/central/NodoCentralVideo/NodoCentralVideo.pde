import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 
import java.net.*;
import java.io.*;
import java.util.*;

// puerto de envio en las pruebas a un solo nodoPantalla
int clientPort = 9000; 
String ip="192.168.0.203";


// Objeto para realizar el envio UDP
DatagramSocket ds; 
Nodo nodoCentral;


//La lista de las imagenes

Lista24F listaImagen;
// las imagenes actuales
PImage imgActual,imgActualMin;


void setup() {
  
  size(1280,200);
  //size(320,240);
  
  // Inicializamos la lista de 24 fotogramas
  listaImagen= new Lista24F(10);
  imgActual=loadImage("error.jpeg");
  
  // creamos el nodo central para la recepcion
  // y el DatagramSocket para realizar los envíos
  try {
    ds = new DatagramSocket(8888);
    nodoCentral= new Nodo(InetAddress.getByName(ip),9000);
    //nodoCentral= new Nodo(InetAddress.getLocalHost(),8888);
  } catch (Exception e) {
    e.printStackTrace();
  }
}
  
 
void draw() {
      
      // dibujamos la lista de las imágenes
      background(0);
      
      // recibimos una imagen mas adelante deberemos determinar de donde viene esa imagen
      imgActual=nodoCentral.recibir();
      
      // ejemplo de introduccion de una imagen fake
      if (mousePressed) 
      {  PImage fake=loadImage("error.jpeg");
         imgActual.blend(fake, 0,0,fake.width,fake.height,0,0,imgActual.width,imgActual.height,MULTIPLY) ;
      }
      nodoCentral.enviar(ds,imgActual);
      listaImagen.borrar();
      listaImagen.insertar(imgActual);
      // es solo para control
      listaImagen.dibujar();
      // tendriamos que enviar de nuevo la imagen al NodoPantalla
      
      
     
}




/*
// Function to broadcast a PImage over UDP
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)


void broadcast(PImage img) {

  // We need a buffered image to do the JPG encoding
  //BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_BYTE_GRAY);

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Get the byte array, which we will send out via UDP!
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("Sending datagram with " + packet.length + " bytes");
  try {
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName(ip),clientPort));
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}
*/
