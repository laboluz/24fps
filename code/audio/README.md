# Documentación Nodo Audio

El nodo de Audio está programado en max-msp (Max8).
La aplicación escucha los mensajes OSC enviados por el nodo principal y reaccionaa ellos determinísticamente cambiando al estado sonoro correspondiente.


Diagrama de flujo general
---

```mermaid
%%Este bloque de código ha sido programado para visualizarse con la integración para Markdown de Mermaid, que permite codificar diagramas de forma humanamente legible
flowchart TB

init1["Estado Ruleta"]
init2["Estado Ruleta"]
init3["Estado Ruleta"]
c1{"Elección\nAleatoria"}
c2{"Elección\nAleatoria"}
real1["Composición-A 10ch"]
real2["Composición-B 10ch"]
fake1["Grabación-A 10ch"]
fake2["Grabación-B 10ch"]

init1 --> c1
c1 -->|A| real1 --> init2
c1 -->|B| real2 --> init2
init2 --> c2
c2 -->|A| fake1 --> init3
c2 -->|B| fake2 --> init3
init3 -.->|bucle| init1
```

