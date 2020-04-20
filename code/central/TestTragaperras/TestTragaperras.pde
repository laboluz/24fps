import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;



// A byte array to read into (max size of 65536, could be smaller)
byte[] buffer = new byte[65536]; 

ImagenTragaperras imagenActual;
ImagenTragaperras[] listaImagenes;
// representa el número de imágenes que vamos a considerar
int nImg=9;
int velocidad=30;
int frameR=60;

// tendremos un estado=0 inicial no hacemos nada, pulsando el digito=0
// estado=1 lanzamos el tragaperras, pulsamos el digito=1
// estado =2 vemos video, a este estado pasamos cuando estando en el
// estado=1 apretamos el ratón
int estado=0;

int numImagenActual=0;


void setup() {
  // tamaño del lienzo
  //size(1280,720,P3D);
  //size(1280,720,P3D);
  size(1280,720);
  // las imágenes estarán en la carpeta data y empezaran por imagenX.jpg
  
  listaImagenes=volcarImagenes("imagen","jpg",nImg);
  estado=0;
  
  numImagenActual=0;
  listaImagenes[numImagenActual].cambiarEstado(1);
  //frame
  frameRate(frameR);
  
  
}

 void draw() {
  // 
  background (0);
   if (estado==1)
   {
   for (int i=0; i<nImg;i++)
   {  listaImagenes[i].dibujar();
   }
   }
}

ImagenTragaperras[] volcarImagenes(String nombre,String extension,int numImagenes)
{  // tendremos que ir al sistema de ficheros y recoger las imágenes 
   // que tenemos almacenadas
   ImagenTragaperras[] listaImagen=new ImagenTragaperras[numImagenes];
   int posicionInicial=0;
   for (int i=0; i<numImagenes;i++)
   {  PImage img= loadImage(nombre+i+"."+extension);
      posicionInicial=posicionInicial-(img.height);
      listaImagen[i]=new ImagenTragaperras(img,velocidad,posicionInicial);
      
   }
      
   return listaImagen;
}



// cambios de estado que se producen, tanto con el ratón como con el teclado

void keyPressed()
{
  if ( key == '1' ) if ((estado==0)||(estado==2)) estado=1;
  if ( key == '2' ) if (estado==1) estado=2; 
  if ( key == '0' ) if ((estado==1)||(estado==2)) estado=0;
  println(" estado=  "+estado);
  }
  
void mousePressed()
{
   if (estado==1) estado=2; 
   else if (estado==2) estado=1; 
    println(" estado=  "+estado);
  
  }
