 class ImagenTragaperras
 { 
    // El elemento principal es una imagen
    PImage img;
    // tendremos dos estados 0 sin dibujar; 1 en proceso de dibujo
    int estado=0;
    // la posición de inicio es (0,720) o (0,heigth de la imagen)
    int posicionActual=0;
    // para realizar el dibujado el incremento que tendremos que hacer
    int incremento=1;
    
    public ImagenTragaperras(PImage img, int incremento,int pos)
    {  //posicionActual= img.height;
       posicionActual=pos;
       this.img=img;
       estado=0;
       this.incremento=incremento;
    }
    
    void cambiarEstado(int e)
    { estado=e; }
    
    void decrementarPosicion()
    {  if (estado==1) posicionActual=posicionActual-incremento;
       if (posicionActual<=0) {estado=0; posicionActual= img.height;}
    }
    
    void incrementarPosicion()
    {   posicionActual=((posicionActual+incremento)%(img.height*(nImg)));
        
        
    }
    
    //El método principal será dibujar la imagen
    void dibujar()
    {    
         //if (esVisible(posicionActual))
         {  
            //image(img,0,posicionActual);
            
             image(img,0,(posicionActual-img.height));
         }
         incrementarPosicion();
    }
    
    boolean esVisible (int pos)
    { //return ((pos>(-img.height))&&(pos<img.height)); 
    return ((pos>(-img.height))&&(pos<img.height)); 
    }
 }
