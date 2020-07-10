/**clase que se corresponde con la lista de Nodos Pantalla donde tendremos
 * que realizar los envíos de las fotos ya convertidos en array de byte
 */

class ListaNodosPantalla
{ 
  // tenemos la lista de nodos Pantalla y el nodo Central
  LinkedList<Nodo> listaNodosPantalla;
  // numero de elementos de la lista
  int num;
  //elementos auxiliares para el envío de los datos a todas las pantallas
  //cuidado REVISAR
  private byte [] buffer=new byte[65536]; 
  
  ListaNodosPantalla(String fichNodos, DatagramSocket ds)
  { // Recuperamos del fichero fichNodos se trata de un formato .csv
    Table datosNodos=loadTable(fichNodos, "header");
    // creamos la lista
    listaNodosPantalla= new LinkedList();
    // recorremos el fichero donde estan los nodosPantalla y vamos creando 
    // los elementos de la lista
    // recorremos las filas de la tabla
    for (int i=0; i <datosNodos.getRowCount(); i++) 
    { // accedemos a cada fila del fichero
      TableRow row  = datosNodos.getRow(i); 
      String ip = row.getString("direccionIP"); 
      int puerto = row.getInt ( "puerto"); 
      Nodo elemento= new Nodo(ip, puerto, ds);
      listaNodosPantalla.add(elemento);
     }
}


  void enviarImagen(PImage img)
  { // tendremos que obtener el array de bytes de la imagen en Blanco y Negro
    // y comprimida a jpg
   
    buffer=comprimir(img);
    // Una vez tenemos el vector de byte recorremos la lista de nodosPantalla
    // y enviamos

    Iterator<Nodo> it = listaNodosPantalla.iterator();
    while (it.hasNext()) {
      Nodo nodoPantalla=it.next();
      nodoPantalla.enviar(buffer);
      //delay(120);
    }
  }

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
}
