/**clase que se corresponde con la lista de Nodos Pantalla donde tendremos
 * que realizar los envíos de las fotos ya convertidos en array de byte
 */

class ListaNodos
{ 
  // tenemos la lista de nodos Pantalla y el nodo Central
  LinkedList<Nodo> listaNodos;
  LinkedList<byte []> listaImagenByte;
  // numero de elementos de la lista
  int num;
  int retardo;
  //elementos auxiliares para el envío de los datos a todas las pantallas
  //cuidado REVISAR
  private byte [] buffer=new byte[65536]; 

  ListaNodos(String fichNodos, byte [] imagenByte, DatagramSocket ds, int numNodos, int retardo)
  { // Recuperamos del fichero fichNodos se trata de un formato .csv
    Table datosNodos=loadTable(fichNodos, "header");
    // creamos la lista
    listaNodos= new LinkedList();
    // recorremos el fichero donde estan los nodosPantalla y vamos creando 
    // los elementos de la lista
    // recorremos las filas de la tabla
    for (int i=0; i <datosNodos.getRowCount(); i++) 
    { // accedemos a cada fila del fichero
      TableRow row  = datosNodos.getRow(i); 
      String ip = row.getString("direccionIP"); 
      int puerto = row.getInt ( "puerto"); 
      Nodo elemento= new Nodo(ip, puerto, ds);
      listaNodos.add(elemento);
    }
    // tendremos que crear la lista de imagenesByte en funcion del numero de nodos y 
    // el retardo que queramos
    // el numero de imagenes que tendremos que manejar es (numNodos*retardo+1)
    // inicialmente creamos la lista con la imagen de 404 error y luego ya iran entrando las nuevas
     listaImagenByte= new LinkedList();
    int n=(numNodos*retardo+1);
    num=numNodos;
    this.retardo=retardo;
    for (int i=0; i <n; i++) 
    {   listaImagenByte.add(imagenByte); }
    
    
  }
  ListaNodos(String fichNodos, DatagramSocket ds)
  { // Recuperamos del fichero fichNodos se trata de un formato .csv
    Table datosNodos=loadTable(fichNodos, "header");
    // creamos la lista
    listaNodos= new LinkedList();
    listaImagenByte=null;
    // recorremos el fichero donde estan los nodosPantalla y vamos creando 
    // los elementos de la lista
    // recorremos las filas de la tabla
    for (int i=0; i <datosNodos.getRowCount(); i++) 
    { // accedemos a cada fila del fichero
      TableRow row  = datosNodos.getRow(i); 
      String ip = row.getString("direccionIP"); 
      int puerto = row.getInt ( "puerto"); 
      Nodo elemento= new Nodo(ip, puerto, ds);
      listaNodos.add(elemento);
    }
  }



  void enviarImagen(PImage img)
  { // tendremos que obtener el array de bytes de la imagen en Blanco y Negro
    // y comprimida a jpg

    //buffer=comprimir(img);
    try{buffer=comprimir(img,0.7f);}
    catch(Exception e){;}
    // Una vez tenemos el vector de byte recorremos la lista de nodosPantalla
    // y enviamos

    Iterator<Nodo> it = listaNodos.iterator();
    while (it.hasNext()) {
      Nodo nodoPantalla=it.next();
      nodoPantalla.enviar(buffer);
      //delay(120);
    }
  }
  
  void enviarImagenByte()
  { // envia las imagenes que estan almacenadas en la lista de bytes
    // segun la estrategia del retraso

    

    Iterator<Nodo> it = listaNodos.iterator();
    byte [] imagenByteActual;
    int index=0;
    
    while (it.hasNext()) {
      Nodo nodoPantalla=it.next();
      imagenByteActual=listaImagenByte.get(index);
      index=index+retardo;
      nodoPantalla.enviar(imagenByteActual);
      //delay(120);
    }
  }
  void enviarImagenByte(byte [] img)
  { // tendremos que obtener el array de bytes de la imagen en Blanco y Negro
    // y comprimida a jpg

    

    Iterator<Nodo> it = listaNodos.iterator();
    
    while (it.hasNext()) {
      Nodo nodoPantalla=it.next();
      nodoPantalla.enviar(img);
      //delay(120);
    }
  }
  
  void enviarByte(byte [] msj)
  { enviarImagenByte(msj);}
  
  void insertarImagenByte( byte [] imagenByte)
  {   // insertar al principio una imagen
      listaImagenByte.addFirst(imagenByte);
  }
  
  void borrarImagenByte()
  {   // borramos la última imagen que insertamos
      listaImagenByte.removeLast();
  }
  void dibujarListaImagenByte()
  { 
     
    for( int j=0; j<4; j++)
    for (int i=0; i<10;i++)
    {   byte [] imagenByteActual=listaImagenByte.get((j+i)+4);
        PImage imagenActual=descomprimir(imagenByteActual);
        int x=(80*i)+240;
        int y=(45*j)+240;
        imagenActual.resize(80, 45);
        image(imagenActual,x,y);
    }
    
  }
  

  

  // pero en caso no querere guardar esta información en el disco
  byte[] comprimir(PImage imagen, float quality) throws IOException {
    // save jpeg image with specific quality. "1f" corresponds to 100% , "0.7f" corresponds to 70%

    BufferedImage bimg = new BufferedImage(imagen.width, imagen.height, BufferedImage.TYPE_BYTE_GRAY);


    // transferimos los pixeles al bufferImagen
    imagen.loadPixels();
    bimg.setRGB( 0, 0, imagen.width, imagen.height, imagen.pixels, 0, imagen.width);

    ImageWriter jpgWriter = ImageIO.getImageWritersByFormatName("jpg").next();
    ImageWriteParam jpgWriteParam = jpgWriter.getDefaultWriteParam();
    jpgWriteParam.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
    jpgWriteParam.setCompressionQuality(quality);

    ByteArrayOutputStream baos = new ByteArrayOutputStream(); 
    jpgWriter.setOutput(new MemoryCacheImageOutputStream(baos));
    IIOImage outputImage = new IIOImage(bimg, null, null);

    jpgWriter.write(null, outputImage, jpgWriteParam);

    baos.flush(); 
    byte[] returnImage = baos.toByteArray(); 
    baos.close();
    jpgWriter.dispose();
    return returnImage;


    //jpgWriter.setOutput(ImageIO.createImageOutputStream(jpegFiletoSave));
    //IIOImage outputImage = new IIOImage(image, null, null);
    //jpgWriter.write(null, outputImage, jpgWriteParam);
    //jpgWriter.dispose();
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
  
  //private byte [] comprimir(PImage imagen)
  //{ 
  //  byte[] packet=null;


  //  BufferedImage bimg = new BufferedImage(imagen.width, imagen.height, BufferedImage.TYPE_BYTE_GRAY);
  //  //BufferedImage bimg = new BufferedImage(imagen.width, imagen.height, BufferedImage.TYPE_INT_RGB);

  //  // transferimos los pixeles al bufferImagen
  //  imagen.loadPixels();
  //  bimg.setRGB( 0, 0, imagen.width, imagen.height, imagen.pixels, 0, imagen.width);
  //  //ColorConvertOp ccop = new ColorConvertOp(ColorSpace.getInstance(ColorSpace.CS_GRAY), null);
  //  //BufferedImage bimg = ccop.filter(bimg1, null);
  //  // Para la comunicacion UDP tenemos que mandar bytes

  //  ByteArrayOutputStream baStream  = new ByteArrayOutputStream();
  //  BufferedOutputStream bos    = new BufferedOutputStream(baStream);

  //  // Ponemos el BufferedImage dentro de un JPG y lo ponemos en el BufferedOutputStream

  //  try {
  //    ImageIO.write(bimg, "jpg", bos);
  //  } 
  //  catch (IOException e) {
  //    e.printStackTrace();
  //  }

  //  // recuperamos byte array, que enviaremos via UDP!
  //  packet = baStream.toByteArray();
  //  //println("el numero de elementos es: "+packet.length);
  //  return packet;
  //}
}
