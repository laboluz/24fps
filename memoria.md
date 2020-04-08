# 24F - Memoria Técnica
(14i+10s)frames(LaboLuz)

## Índice
1. Idea de la instalación.
2. Estructura general de la Aplicación.
3. Propuesta de especificación de la Aplicación Distribuida.
4. Diagramas de estados de cada uno de los tipos de Nodos (falta).
5. Esquema de comunicación entre los diferentes Nodos. (falta)
6. Pruebas de programación en Processing/Java (falta adecuar)


## 1.- Idea de la instalación
24F es una instalación pensada para ser presentada en el Hall del IVAM. La instalación está formada por 3 sensores, dos de imagen y uno de sonido, 14 pantallas colocadas en serie y 10 monitores de audio. A grandes rasgos lo que se pretende desde el punto de vista técnico es recoger imágenes y sonidos del espacio a través de cámaras y por un lado enviar las imágenes en ocasiones procesadas a 14 pantallas, en las que los fotogramas vayan pasando de una a otra de forma secuencial, y por otro enviar sonidos en ocasiones procesado a los 10 monitores de audio, de forma que vayan pasando de un monitor a otro. Las pantallas estarán ubicadas a lo largo de la barandilla del primer piso del Hall del IVAM, los monitores de audio en el pasillo del cuarto de baño del segundo piso y los 3 sensores distribuidos entre el primer y segundo piso. En la fig.1 nos podemos hacer una idea del esquema de la instalación (he reutilizado la imagen que mandó María José).

![Figura 1. Esquema general de la instalación]()


Se quiere diseñar una Aplicación Distribuida que gestione todas las partes que forman la instalación. Para la gestión de esta instalación tendremos los siguientes tipos de nodos (ordenadores):
- 1.Nodos Araña, que recogen información del entorno: sonido, imagen, presencia. De momento tendremos 3, dos con cámara y uno con micrófono.
- 2.Nodos Pantalla, cada nodo gestiona dos pantallas. Hay un total de 7, y cada Nodo Pantalla gestiona dos monitores de video.
- 3.Nodo Central, que coordina a los nodos araña y nodos Pantalla y gestiona el sonido de los 10 monitores de audio.
- 4.Nodo Monitor, presenta una visualización creativa de todos los datos presentes en la aplicación distribuida. (este tipo de nodo es unapropuesta NUEVA).


## 2.- Estructura general de la Aplicación
En la fig. 2 se puede observar la relación que existe entre las diferentes partes de la aplicación.

![Figura 2. Relación entre las diferentes partes de la aplicación]()


## 3.- Propuesta de especificación de la Aplicación Distribuida
De forma simplificada el funcionamiento del sistema debe ser capaz de abordar las siguientes acciones para cada uno de los tipos de Nodos, salvo los requisitos de transferencia de datos que se aplican a todos:
* NODOS ARAÑA con cámara:
  - generación de imágenes,
  - generación de presencia.
* NODO ARAÑA con micrófono:
  - generación de sonidos,
  - generación de presencia.
* NODO CENTRAL
  - procesamiento de imágenes,
  - procesamiento y presentación de sonido.
  - gestión del cambio (control de estados de la aplicación distribuida).
* NODOS PANTALLA
  - presentación de imágenes.
* NODO MONITOR
  - monitorización de la aplicación.
* GENERAL TODOS LOS NODOS
  - gestión de la transferencia de datos por la red.

A continuación, se detallen cada una de las funcionalidades que queremos que tenga nuestra aplicación:

* **a) Generación de Imágenes**
  Los Nodos Araña con cámara deberán recoger con la frecuencia que se establezca una imagen a través de su cámara. Esta imagen debe estar en blanco y negro y se debe comprimir a JPEG, de manera que su tamaño final sea como máximo de 65000 bytes.
  >(NOTA hemos realizado pruebas y con una resolución de 1280x720, usando un canal de color y con un nivel de compresión jpeg medio, se obtienen imágenes de aproximadamente 65000 bytes).

  Una vez generada la imagen se envía por el protocolo de comunicación UDP dicha imagen al Nodo Central, únicamente hay que mandar un paquete. El tamaño máximo del paquete para mandar con este protocolo es exactamente 65000 bytes. (propuesta de envío del mismo mensaje al Nodo Monitor).  

  Para generar las imágenes el Nodo Araña tendrá que estar en estado de ejecución. En general los Nodos Araña tendrán dos estados o situaciones:
  1. Estado pasivo. No se hace nada.
  2. Estado de captura cámara. Se capturan imágenes y se mandan.

  El cambio de estado lo decide el Nodo Central, mandándole al Nodo Araña un mensaje mediante el protocolo UDP.

* **b) Generación de Presencia**
  Los Nodos Araña con cámara y micrófono deberán recoger con la frecuencia que se establezca información referente a la presencia de personas en espacio. Este dato puede ser muy simple, y con dos valores será suficiente: 0 poca gente; 1 mucha gente.
  (NOTA: Como orientación para recoger la presencia apuntamos:
    - En el caso del Nodo Araña con micrófono, se establecen los dos niveles en función del volumen que recoja el micro, diseñando un umbral. Para evitar ruidos altos puntuales se deberá comprobar que el sonido es alto durante un periodo de tiempo.
    - En el caso de los Nodos Araña con cámaras, se establecen los dos niveles en función del resultado de restar el fotograma actual de la cámara con un fotograma guardado con el espacio sin gente. Si sumamos el resultado de la resta y el valor supera un umbral se decide que hay mucha gente. La suma se puede hacer simultáneamente con la resta de las imágenes. Además, se pueden tener imágenes guardadas del espacio sin gente e determinadas horas del día.)

  Una vez generada la información de presencia se envía por el protocolo de comunicación UDP dicha información al Nodo Central, únicamente hay que mandar un paquete.
  Para generar la presencia, el Nodo Araña tendrá un estado adicional que denominamos, estado de presencia activa:
    - El cambio de estado lo decide el Nodo Central, mandándole al nodo Araña un mensaje mediante el protocolo UDP.  
    >(NOTA con una programación adecuada de la concurrencia el Nodo Araña podría estar simultáneamente calculando presencia y mandando imágenes.)

* **c) Generación de Sonidos**
  Nodos Araña con micrófono deberán recoger con la frecuencia que se establezca un buffer de sonido de su micrófono (realmente de su tarjeta de sonido o conversor analógico digital).  
  >(NOTA Un buffer de sonido es un pedacito de sonido, por ejemplo 512 números suele ser un tamaño habitual).  

  Se debe conocer la frecuencia de muestreo del sonido para posteriormente reproducirlo de forma correcta desde el Nodo Central, asumiremos 44100 o menos.Una vez obtenido el buffer se envía por el protocolo de comunicación UDP alNodo Central, únicamente hay que mandar un paquete. Utilizando este sistema únicamente se manda un pedazo muy pequeño de sonido y lo mismo que la imagen nunca va a llegar continua el sonido tampoco llegará continuo.Para generar el sonido, el Nodo Araña tendrá que estar en estado de ejecución. En general los Nodos araña tendrán dos estados, en relación a la generación de sonido:
    1. Estado de sonido activo. Se recogen y se mandan los buffers.
    2. Estado de sonido pasivo. No se hace nada.El cambio de estado lo decide el Nodo Central, mandándole al Nodo Araña un mensaje mediante el protocolo UDP.

* **d) Procesamiento de Imágenes**
  El Nodo Central es el encargado de realizar el procesamiento de las imágenes. Para ello dispone de una lista de las últimas 16 imágenes enviadas a los Nodos Pantalla. Cuando le llega una nueva imagen del Nodo Araña la procesa o no dependiendo del estado en que se encuentre, borra laúltima imagen de la lista e inserta la nueva. Una vez actualizada la lista, tiene que enviar las imágenes a los Nodos Pantalla
  >(NOTA si cada uno de estos nodos gestiona dos monitores pues mandará dos imágenes, en dos mensajes diferentes).

  Para mandar las imágenes se seguirá el mismo criterio que en los Nodos Araña, la imagen debe estar en blanco y negro y comprimida en jpg, de manera que no ocupe más de 65000 bytes (factor de compresión medio). El protocolo que se usará para mandar las imágenes es el UDP.

  Antes de actualizar la lista de imágenes y enviarlas se deberá procesar en caso que sea necesario la imagen recogida de los Nodos Araña. Para el procesamiento se pueden dar tres situaciones:
    1. La imagen, sin procesar se pasa a la lista.
    2. A la imagen se le añaden textos.
    3. La imagen se fusiona con otras imágenes.

  En el **caso 1**, no se tiene que hacer nada.  
  En el **caso 2**, se debe de disponer de los textos en una lista (previamente estarán en un fichero XML o similar) y añadir a la imagen algún texto de la lista. La gestión de la lista de textos está por definir.  
  En el **caso 3**, se debe disponer de listas de imágenes fake para fusionar, estas imágenes puesto que representan objetos en movimiento deberán estar perfectamente ordenadas con la finalidad de recoger la imagen correcta en cada momento y mediante algún método de fusión, mezclamos la imagen fake con la imagen.

  De lo anterior tenemos que, para el procesamiento de las imágenes, el NodoCentral podrá estar en 3 estados:
  1. Estado normal.
  2. Estado de fusión fake.
  3. Estado de texto.

  El cambio de estado lo decide el Nodo Central, en función de los datos de presencia que reciba de los Nodos Araña, de forma aleatorio, en función de la hora del día ... Además, puesto que el Nodo Central recibe imágenes de dos Nodos Araña, cada uno de los tres estados se subdivide en 2 estados adicionales en función del Nodo Araña que este enviando imágenes. El cambio de estado de estos sub estados estará en función de datos de presencia de los Nodos Araña, de forma aleatorio, hora del día ...

* **e) Procesamiento y presentación de sonido**
  El Nodo Central es el encargado de realizar el procesamiento y la presentación del sonido en los 10 Monitores de sonido. El planteamiento del sonido es casi SIMETRICO al de las imágenes.  

  Para el procesamiento del sonido se dispone de una lista de los últimos 10 buffers de sonido enviados a los Monitores. Cuando le llega un nuevo buffer, lo procesa o no dependiendo del estado en que se encuentre, borra el último buffer de la lista e inserta el nuevo.

  Para presentar el sonido, una vez actualizada la lista, se recorrerán sus elementos y se mandarán esas muestras de sonido a cada uno de los Monitores de audio. Tiene que enviar el sonido a los Monitores como se representa en la figura 3.

  ![Figura 3. Lista de buffers relacionados con los monitores de Audio.]()

  El proceso de forma similar al de las imágenes consiste en borrar el último buffer e insertar en la cabeza de la lista el actual.
  >(NOTA A diferencia del tratamiento de la imagen, donde las imágenes que se mandan a los Nodos Pantalla son reconocibles y muestran el espacio visual, con el sonido se plantea una solución no realista y la composición sonora que se presenta está basada en el sonido del espacio, pero con un resultado nuevo e irreconocible al sonido que se está produciendo en la sala. Estas ideas están basadas en el artículo [“Filling Sound with Space: an elemental approach to sound spatialisation”](https://www.researchgate.net/publication/329845938_Filling_Sound_with_Space_An_elemental_approach_to_sound_spatialisationbuffer) de Joan Riera)

  Siguiendo el mismo esquema que en la imagen, para el procesamiento del sonido se pueden dar tres situaciones:
    1. El buffer, sin procesar se pasa a la lista.
    2. El buffer se fusiona con otros sonidos “musicales” grabados en el mismo espacio.
    3. El buffer se fusiona con el sonido los textos.En el caso 1, no se tiene que hacer nada.

  En el **caso 2**, se debe de disponer de una lista con buffers de sonidos anteriormente grabados en el espacio generados con instrumentos (NOTA la idea es realizar alguna improvisación sonora en el espacio y grabarla) y presentar estos sonidos en los Monitores.  
  En el **caso 3**, se debe disponer de listas de buffers con el sonido de los textos (NOTA previamente estarán en un fichero XML y se habrán grabado de forma manual o mediante técnicas de síntesis de voz) y mezclarlo con los buffers enviados por los Nodos Araña.

  De lo anterior tenemos que, para el procesamiento del sonido, el Nodo Central podrá estar en 3 estados:
    1. Estado normal.
    2. Estado de fusión fake/sonidos musicales.
    3. Estado de texto.

  Para simplificar se propone que los cambios de estado del procesamiento del sonido sean simétricos al cambio de estado del procesamiento de imagen y por lo tanto los estados que gestionan el procesamiento del sonidoson los mismos que para el procesamiento de la imagen.

* **f) Presentación de imágenes**
  Los Nodos Pantalla son los encargados de presentar las imágenes en las pantallas. Cada Nodo Pantalla tendrá a cargo dos Monitores de video. Las imágenes le llegarán vía paquetes UDP desde el Nodo Central, su único acometido es presentar las imágenes debidamente en cada uno de los dos Monitores.
  >(NOTA Si se dota de funcionalidad táctil a las PANTALLAS, el usuario podría interactuar con ellas y se podría definir un funcionamiento más sofisticado).

  Únicamente tiene dos estados ejecución y parada.Con la finalidad de no sobrecargar el Nodo Central, los Nodos Pantalla deberán replicar los mensajes que les llega del Nodo Central al Nodo Monitor.

* **g) Gestión del cambio (control de estados de la aplicación)**
  A lo largo de la descripción de las acciones anteriores que debe abordar la aplicación distribuida se han ido esbozando los cambios de estado de cada uno de los Nodos en función de los datos recibidos a través de mensajes o situaciones de aleatoriedad o consulta de la hora. En general y hasta que estén definidos claramente los denominamos DATOS de CAMBIO.

  Los Datos que provocan cambios serán:
    - Presencia de volumen alto
    - Presencia de personas
    - Generación de aleatoriedad
    - Consulta de la hora del sistema.

    De momento se deja abierto el poder incluir otros datos que provoquen los cambios de estado.

* **h) Gestión de la transferencia de datos**
  Con la finalidad de uniformar el envío de datos entre los diferentes componentes de software de la aplicación distribuida, se va a usar, como yase ha apuntado en la descripción de las acciones anteriores, el protocolo de comunicación UDP. Éste protocolo tiene un tamaño máximo de paquete de 65000 bytes, tamaño suficiente para mandar imágenes en formato JPG de resolución 1280x720 en blanco y negro y con índice de compresión medio. Todos los tipos de Nodos definidos en la aplicación deberá implementar la funcionalidad de envío y recepción de este tipo de paquetes dentro del protocolo. El protocolo UDP supone una comunicación sin establecimiento de llamada, es el equivalente al correo postal, y es la forma más rápida de enviar información sin saturar la red. Para la aplicación es el más idóneo puesto que si se pierde algún mensaje que contenga imagen al instante siguiente se enviará otra, no siendo importante esa pérdida. Lo tipos de mensajes que usará la aplicación son:
    1. Mensaje de imagen
    2. Mensaje de buffer de sonido
    3. Mensaje de cambio de presencia
    4. Mensaje de cambio de estado.

  Con la finalidad de uniformar la recepción y envío de mensajes se propone usar el primer byte del mensaje para identificar el tipo de mensaje. Donde 1 será para mensaje de imagen, 2 mensaje de buffer de sonido, 3 mensaje depresencia, 4 mensaje de cambio de estado.  

  Con la finalidad de uniformar la gestión de mensajes la recepción de los mensajes se realizará en el puerto 8088.

  A continuación, se detallan las características de cada uno de los tipos de mensaje:
    1. **Mensaje de Imagen**. Este tipo de mensajes se envían de los Nodos Araña al Nodo Central y del Nodo Central al Nodo Pantalla y del Nodo Pantalla al Nodo Monitor (cabe la posibilidad de eliminar este último envío). En la recepción de estos mensajes en Nodo Central, para diferenciar entre el Nodo Araña 1 y el Nodo Araña 2 de imagen, se usará el segundo bye del mensaje, con valor 1 y 2 respectivamente. Esto habrá que tenerlo en cuenta en la construcción del mensaje en los Nodos Araña. Esto supone que potencialmente perdemos 2 bytes de la imagen original, que podrían ser reubicados al final y luego para la presentación final vueltos a recolocar. Para el envío de las imágenes a los Nodos Pantalla no se usará este byte, puesto que no se necesita realizar ninguna distinción.
    2. **Mensaje de buffer de sonido**. Para este tipo de mensajes no se necesita ningún dato adicional. Se asume una frecuencia de muestreo de 44100 Hz. Por un lado, estos mensajes son generados por el Nodo Araña de Sonido y los recibe el Nodo Central, y por otro una vez procesado el sonido en el Nodo Central, este construye y envía un mensaje de este tipo al Nodo Monitor (NOTA cabe la posibilidad de eliminar este envío y que el Nodo Araña mande directamente el mensajeal Nodo Monitor).
    3. **Mensaje de presencia**. En este tipo de mensajes se necesita saber cuál es el Nodo Araña que ha generado el dato de presencia, para ello vamos a usar el segundo byte del mensaje, con el valor 1,2 y 3 para identificar los Nodos Araña 1,2 y 3 respectivamente. Para saber si hay o no presencia se va a usar el tercer byte de manera que si tiene un valor 0 quiere decir poca gente y 1 mucha gente. Estos mensajes los generan los Nodos Araña y los reciben el Nodo Central y el Nodo Monitor.  
    4. **Mensajes de cambio de estado**. Este tipo de mensajes son generadospor el Nodo Central y los reciben los Nodos Araña. Mediante el segundo byte establecemos que tipo de cambio se produce. Los casos que se presentan son los siguientes:
      - El valor 1 indica reposo de cámara o de sonidob.
      - El valor 2 indica actividad de cámara o de sonidoc.
      - El valor 3 indica reposo generación de presenciad.
      - El valor 4 indica actividad en el cálculo de la presencia.
    >NOTA: Estos posibles estados podrían simplificarse en solo dos valores de manera que el valor 1 indique actividad de cámara o de sonido e inactividad de cálculo de presencia y el valor 2 indique reposo de cámara y sonido y actividad de cálculo de la presencia.

  * **i) Monitorización de la aplicación**.
  El Nodo Central es el encargado de gestionar la aplicación completa y por lo tanto el que en todo momento posee los datos de cambio, las imágenes y los sonidos. En general pasan por él todos los datos que generan los Nodos Araña, todas las imágenes que se envían a los Nodos Pantalla, todos los sonidos que se envían a los Monitores de sonido y los cambios de estado propuestos a los Nodos Araña.  

  La presentación visual de todo este trasiego de información inicialmente se diseñará con un objetivo de depuración de errores de la aplicación, pero sería muy interesante presentarla de forma creativa al público. Para abordaresta funcionalidad y teniendo en cuenta que el diseño visual de esta parte es un proceso que consume muchos recursos del ordenador.

  **Se propone** realizar esta tarea en un cuarto tipo de Nodo, el **Nodo Monitor**. A este Nodo Monitor le debe llegar toda la información que gestiona el Nodo Central, bien directamente desde el Nodo Central o bien desde los Nodos Araña.  

  Teniendo en cuenta los diferentes tipos de mensaje que maneja la aplicación, para descentralizar el envío de datos al Nodo Monitor se propone:
  * Nodo Central reenvía al Nodo Monitor:
    - Mensajes de cambio de estado a los Nodos Araña.
    - Mensaje de buffer Sonido procesado actual.
    - Mensaje de imagen
  * Nodo Araña reenvía al Nodo Monitor:
    - Mensaje de cambio de presencia


## 4.-Diagramas de Estados de cada uno de los Nodos de la Aplicación
Una vez establecida la funcionalidad que se quiere otorgar a los diferentes elementos que conforman la Aplicación Distribuida, vamos a revisar con más detalle el ciclo de vida de cada uno de los componentes. Además de los estados que ya hemos apuntado en la especificación de la aplicación para cada uno de los Nodos, añadimos dos estados que se corresponden con el estado inicial y final de la aplicación.

* NODO PANTALLA
  Este es el más sencillo, y carece de estados. En cuanto se pone en ejecución se queda esperando mensajes de imagen, las muestras en sus dos pantallas y reenvía esas imágenes al Nodo Monitor.

* NODO MONITOR
  La funcionalidad de este nodo todavía no está definida, simplemente debe presentar una visualización creativa de los flujos de datos que transitan por la aplicación. En cuanto se pone en ejecución recibe mensajes y los presenta en su Pantalla.

* NODO ARAÑA
  Los Nodos Araña tienen 4 estados, y su ciclo de vida se puede ver en la figura X.Siguiendo el esquema de la figura.

* NODO CENTRAL

....
