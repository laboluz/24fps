import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;



// puerto para recibir
int port = 9000; 
DatagramSocket ds; 
// el byte para realizar la lectura
byte[] buffer = new byte[65536]; 
// la imagen a visualizar
PImage video;

void setup() {
  size(1280,720);
  //fullScreen();
  try {
    ds = new DatagramSocket(port);
  } catch (SocketException e) {
    e.printStackTrace();
  } 
  //video = createImage(1280,720,RGB);
  video = createImage(1280,720,RGB);
}

 void draw() {
  // recibimos la imagen
  recibir();

  // Dibujamos la imagen
  background(0);
  imageMode(CENTER);
  image(video,width/2,height/2);
}

void recibir() {
  DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
  try {
    ds.receive(p);
  } catch (IOException e) {
    e.printStackTrace();
  } 
  byte[] data = p.getData();

  println("recibimos el datagrama: " + data.length + " bytes." );

  // leemos los datos dentro de ByteArrayInputStream
  ByteArrayInputStream bais = new ByteArrayInputStream(data);

  // tendremos que desomprimir la imagen jpg y ponerla en unaPImage 
  video.loadPixels();
  try {
    // Hacemos un BufferedImage out para recibir los bytes
    BufferedImage img = ImageIO.read(bais);
    // ponemos los pixeles en  PImage
    img.getRGB(0, 0, video.width, video.height, video.pixels, 0, video.width);
  } catch (Exception e) {
    e.printStackTrace();
  }
  // actualizamos la PImage
  video.updatePixels();
}
