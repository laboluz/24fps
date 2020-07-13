

// Esta clase es la superclase de los diferentes tipos de nodos de la apliación 
class Nodo
{   

  // representa un puerto y una dirección IP
  
  int puerto=0;
  InetAddress direccionIP;
  
  // Socket para realizar envío y recepción 
  DatagramSocket ds; 
  

  // De forma temporal almacen de la
  // imagen
  byte [] buffer=new byte[65536]; 
  

  Nodo(String ip,int p,DatagramSocket ds)
  { 
    // puerto de envío
    puerto=p;
    try { direccionIP=InetAddress.getByName(ip);} 
    catch (IOException e) { e.printStackTrace();}
    this.ds=ds;
    
  }
  Nodo(DatagramSocket ds)
  { 
    // puerto de envío
    puerto=8880;
    try { direccionIP=InetAddress.getLocalHost();} 
    catch (IOException e) { e.printStackTrace();}
    this.ds=ds;
    
  }
  
  // Enviar una array de byte a la dirección ip y al puerto correspondiente
  void enviar(byte [] buffer)
  { 
   
    try { ds.send(new DatagramPacket(buffer, buffer.length,direccionIP,puerto)); 
          print(direccionIP.getHostAddress());
          println(","+puerto);
          println(buffer.length);
          
        } 
    catch (Exception e) { e.printStackTrace();}
  }
  
  byte [] recibir() {
    DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
    try { ds.receive(p);} 
    catch (IOException e) { e.printStackTrace();} 
    byte[] data = p.getData();
    return data;
  }

}
    
    
