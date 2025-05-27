# Speedmatx

Speedmatx es un proyecto que integra hardware y software para la creación de un sistema de juego interactivo, diseñado principalmente para pruebas de agilidad mental, registro de usuarios y gestión de puntuaciones. El proyecto combina diferentes tecnologías y lenguajes, como Arduino, Processing, comunicaciones WiFi y una base de datos para el almacenamiento de resultados.

---

## Tabla de contenidos

- [Descripción general](#descripción-general)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Características principales](#características-principales)
- [Componentes de hardware](#componentes-de-hardware)
- [Componentes de software](#componentes-de-software)
- [Instalación](#instalación)
- [Uso](#uso)
- [Contribuciones](#contribuciones)
- [Licencia](#licencia)

---

## Descripción general

Speedmatx es un sistema interactivo que utiliza placas Arduino y módulos WiFi para conectar un juego escrito en Processing con una base de datos, permitiendo almacenar y consultar resultados de los usuarios en tiempo real. El juego está orientado a medir la velocidad de respuesta y precisión del usuario, mostrando letras aleatorias y cronometrando el tiempo que tarda en resolver el reto. Al finalizar, se registra el resultado en una base de datos, permitiendo la creación de un ranking.

---

## Estructura del proyecto

La estructura principal del repositorio es la siguiente:

```
/
├── Arduino/
│   ├── Processing_al_Arduino_funcional/
│   ├── PRocessing_to_Lolin_to_api_bd/
│   ├── Prueba_peticion_server/
│   ├── lolin/
│   └── libraries/
├── juegofinnn/
│   └── juegofinnn.pde
└── README.md
```

### Resumen de carpetas y archivos:

- **Arduino/**: Contiene los distintos sketches y pruebas para la comunicación entre Arduino y otros dispositivos/software.
    - **Processing_al_Arduino_funcional/**: Ejemplo de comunicación básica entre Processing y Arduino usando serial.
    - **PRocessing_to_Lolin_to_api_bd/**: Código para enviar datos desde Processing, pasando por una placa Lolin (ESP8266), hacia una API que registra en base de datos.
    - **Prueba_peticion_server/** y **lolin/**: Pruebas de conexión WiFi y peticiones HTTP desde Arduino hacia el servidor.
    - **libraries/**: Librerías necesarias para el funcionamiento, como RTClib (para manejo de reloj en tiempo real), EspSoftwareSerial, Adafruit Circuit Playground, entre otras.
- **juegofinnn/**: Juego principal realizado en Processing, que genera el reto, controla el tiempo, recoge el nombre del usuario y envía los resultados.

---

## Características principales

- **Juego interactivo de agilidad mental:** Presenta letras aleatorias que el usuario debe identificar en un tiempo limitado, con penalizaciones por uso de pistas.
- **Temporizador y gestión de ranking:** Cronometra el tiempo de resolución y almacena los resultados en una base de datos tipo ranking.
- **Integración hardware-software:** Comunicación entre Processing y Arduino para interacción física y registro de datos.
- **Conexión WiFi y peticiones HTTP:** El sistema puede enviar resultados a un servidor vía WiFi usando módulos ESP8266.
- **Uso de librerías externas:** Utiliza librerías como RTClib (manejo de reloj en tiempo real), Adafruit Circuit Playground, y EspSoftwareSerial.
- **Código modular y varios ejemplos:** Incluye diferentes sketches y pruebas para facilitar la ampliación o personalización del sistema.

---

## Componentes de hardware

- Placa Arduino (por ejemplo, ESP8266 Lolin)
- Módulo WiFi (integrado en ESP8266)
- Conexión por puerto serie entre Arduino y el computador que ejecuta Processing
- (Opcional) Sensores y actuadores para ampliar la interacción física

---

## Componentes de software

- **Processing**: Motor principal del juego, interfaz gráfica y lógica de usuario (ver `juegofinnn.pde`).
- **Arduino IDE**: Para cargar los sketches a la placa.
- **Librerías Arduino**: 
    - RTClib (manejo de tiempo real)
    - EspSoftwareSerial (comunicación serial por software)
    - Adafruit Circuit Playground (sensores y actuadores)
- **Servidor backend/API**: Para recibir y almacenar los resultados enviados desde Arduino (la dirección IP y la ruta deben configurarse según tu entorno).

---

## Instalación

1. **Clona el repositorio:**

   ```sh
   git clone https://github.com/leandro-bm/Speedmatx.git
   ```

2. **Instala las librerías de Arduino:**
   - Dirígete a `Arduino/libraries/` y sigue las instrucciones en `readme.txt` o visita [Guía de bibliotecas de Arduino](http://arduino.cc/en/Guide/Libraries).

3. **Carga los sketches necesarios en tu placa Arduino** usando el IDE.

4. **Abre el juego en Processing** (`juegofinnn/juegofinnn.pde`) y ejecútalo.

5. **Configura el servidor backend/API** para recibir los datos (la url está en los sketches, personalízala según tu red).

---

## Uso

1. Inicia el juego en Processing.
2. Introduce tu nombre cuando se solicite.
3. Pulsa el botón "Iniciar" para comenzar el reto.
4. Resuelve el reto lo más rápido posible.
5. Si necesitas ayuda, pulsa "Pista" (añade penalización de tiempo).
6. Al completar el reto, tu tiempo se envía automáticamente al servidor y aparece en el ranking.
7. Puedes modificar y ampliar el sistema añadiendo nuevas pruebas, sensores, o mejorando la comunicación.

---

## Contribuciones

¡Las contribuciones son bienvenidas! Puedes enviar pull requests con mejoras en el código, documentación o sugerencias para nuevas funcionalidades.

---

## Licencia

Este proyecto está bajo una licencia abierta. Consulta el repositorio para más detalles o añade tu propia licencia según tus necesidades.

---

Si necesitas personalizar el README o tienes dudas sobre alguna parte del sistema, házmelo saber y haré los cambios que necesites.
