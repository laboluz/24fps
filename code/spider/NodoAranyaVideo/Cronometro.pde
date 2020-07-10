class Cronometro
{   
  long tiempoInicial;
  long tiempoFinal;
  

  Cronometro()
  {   
    //tiempoInicial=System.currentTimeMillis();
    tiempoInicial=0;
    tiempoFinal=0;
  }

  // pasamos el tiempo del cronometro en milisegundos
  void start(long hora)
  {  //tiempoInicial=System.currentTimeMillis();
     tiempoInicial=millis();
     tiempoFinal=hora;
  }
  void stop()
  {  //tiempoInicial=System.currentTimeMillis();
     tiempoInicial=0;
     tiempoFinal=0;
  }
  
  // devuelve true si ha pasado el tiempo programado, false en caso contrario
  boolean end()
  {    
    long tiempoActual= millis()- tiempoInicial;
    if (tiempoActual>=tiempoFinal) return true;
    else return false;
  }
  void dibujar()
  {   
       long tiempoActual= millis()- tiempoInicial;
       text( tiempoActual, 20, 20);
  }
}
