
Notas a la version V7

1) Se ha probado toda la aplicaciÛn con dos c·maras y todo funciona ok!
2) En nodoAraÒa arranca en el estado = 0 y hay que pasarlo al estado =1 por el nodoCentral o directamente
3) El nodo central hay que pasarlo con la tecla b al estado=1, para que todo funcione.
4) Hay que revisar todas las ip en los ficheros correspondientes de la carpeta data, ojo dentro del programa no hay que modificar nada, solo
 la lista de nodosPantalla y de todosLosNodos y en el nodoAraÒa la direcciÛn del nodo central tambien en el fichero aparte.



Version V6

1) el arranque de nodoAranya, es en el estado=0 y pulsando el 1 se pasa al estado=1, pulsando el 2 se pasa al estado=2 que es con fake
 y con el 0 se vuelve al estado =0. La otra forma de que cambia de estado este nodo es mediante los mensajes del nodoCentral, que envÌa el 2 que identifca
a la aranya 2 y luego el estado al que se pasa 20,21,22, esto provoca el cambio de estado.

2) En el nodoCentral, hay dos estados, estado=1 que activa la recepciÛn de mensajes y el estado=0 que la desactiva. Para el cambio de estado de prueba
lo que tendremos es que la letra a pasa al estado 0 y la letra b al estado=1. En el campo de texto se pueden mandar mensajes al nodo aÒara y al resto
con las codificaciones correspondientes XY, donde X identifica al nodo y Y es el estado al que pasa.

3) cuando en el draw del nodoCentral se activa el envÌo se envian las imagnes a los nodosPantalla, que de momento en esta versiÛn solo se ha probado que
reciben las im·genes.

4) en el nodoCentral en la carpeta data est·n los ficheros que contienen las direcciones de todos los nodos y puertos para envÌo de control nodosControl.csv y
lo mismo con los nodosPantalla.csv

5) En el  nodo central cuando llegan las im·genes comprimidas se guardan en una lista y se enviÌan a las pantallas con el retraso que marca el constructor de
de Lista de Nodos, esta clase se ha ampliado para manejar esta lista que es una linkedList. Se asume que la complejidad para acceder de forma directa a cada
uno de sus elementos es constante, pero esto tendr· que verificarlo.

6) Cuando los ficheros con las direcciones y puertos de envÌo son correctas, todos los datos de control para la aranya y para los nodosPantalla funcionan
correctamente.

7) Se han realizado pruebas con el router TP-link AC1720 y solo con la wifi el sistema de las pantallas se colapsa con solo dos raspberry. Se ha realizado otra
prueba conectando nodoCentral y pantallas directamente al router por cable y el sistema funciona muy bien, lo ˙nico que va por wifi es la araÒa de imagen.

8) Se han puesto videos de prueba para hacer el efecto de la ruleta en los NodosPantalla, cuando llega el mensaje 12,13,14, se activan los videos de ruleta para pasar de forma automatica de nuevo al estado de ejecuciÛn. Se pueden hacer pruebas desconectando los hilos de llegada, y usando las teclas de 0,1,2,3,4 para
realizar los correspondientes cambios de estado. No obstante la reproduccion de los videos de ruleta es muy lenta. Buscamos otras soluciones.
