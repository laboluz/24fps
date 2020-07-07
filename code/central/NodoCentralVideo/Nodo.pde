class Nodo
{   
    //PImage imagen;
    InetAddress direccion;
    int puerto;
    // de momento 1 normal, 0 incio, 2 descontrol
    int estado;
    byte[] buffer; 
    PImage video; 
    
    Nodo(InetAddress d, int p)
    {  direccion=d;
       puerto=p;
       //imagen==loadImage("error.jpeg");
       estado=0;
       buffer = new byte[65536]; 
       video = createImage(1280,720,RGB);
       
    }
    
    
    // Acceso y modificacion de todos los parametros
    // Dibujar correspondiente
    void enviar(DatagramSocket ds, PImage imagen)
    { 
      byte[] packet=null;
      BufferedImage bimg = new BufferedImage(imagen.width,imagen.height, BufferedImage.TYPE_BYTE_GRAY);
      //BufferedImage bimg = new BufferedImage( imagen.width,imagen.height, BufferedImage.TYPE_INT_RGB);
      // transferimos los pixeles al bufferImagen
      imagen.loadPixels();
      bimg.setRGB( 0, 0, imagen.width, imagen.height, imagen.pixels, 0, imagen.width);
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
     

      // enviamos el JPEG como un datagram
      println("Enviando datagram con " + packet.length + " bytes"+" a la direccion:  "+ direccion);
      println("tamanyo de la imagen " + imagen.pixels.length + " bytes"+" a la direccion:  "+ direccion+" puerto: "+puerto);
      try {
          //ds.send(new DatagramPacket(packet,packet.length, direccion,9000));
           ds.send(new DatagramPacket(packet,packet.length,InetAddress.getByName("192.168.0.203"),9000));
          println(" a la direccion:"+ip);
          //ds.send(new DatagramPacket(packet,packet.length, InetAddress.getLocalHost(),clientPort));
          } 
        catch (Exception e) {
        e.printStackTrace();
   }
    }
    
  PImage recibir() {
  
  DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
  try {
    ds.receive(p);
  } catch (IOException e) {
    e.printStackTrace();
  } 
  byte[] data = p.getData();
  

  println("Received datagram with " + data.length + " bytes." );

  // Read incoming data into a ByteArrayInputStream
  ByteArrayInputStream bais = new ByteArrayInputStream( data );

  // We need to unpack JPG and put it in the PImage video
  
  video.loadPixels();
  try {
    // Make a BufferedImage out of the incoming bytes
    BufferedImage img = ImageIO.read(bais);
    // Put the pixels into the video PImage
    img.getRGB(0, 0, video.width, video.height, video.pixels, 0, video.width);
  } catch (Exception e) {
    e.printStackTrace();
  }
  // Update the PImage pixels
  video.updatePixels();
  return video;
}
}
