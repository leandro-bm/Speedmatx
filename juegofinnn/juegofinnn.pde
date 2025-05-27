import java.util.Random;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.SQLException;
import processing.serial.*;

Connection conn;
Statement stmt;
Serial puertoSerie = null;
boolean resultado = false;

class Puntaje implements Comparable{
  String nombre;  // Nombre del usuario
  int tiempo;     // Tiempo en segundos

  // Constructor de la clase Puntaje
  Puntaje(String nombre, int tiempo) {
    this.nombre = nombre;
    this.tiempo = tiempo;
  }
    public int compareTo(Object o)
    {
        Puntaje rhs = (Puntaje)o;

        if (tiempo > rhs.tiempo)
            return 1;
        else if (tiempo < rhs.tiempo)
            return -1;
        else
            return 0;
    }
}

char[] letrasIngresadas = new char[6]; // Letras ingresadas por el usuario
boolean juegoIniciado = false; // Controla si el juego ha comenzado

// Variables del juego (segundo código)
int tiempoInicial = 60; // Tiempo inicial en segundos
int tiempoRestante;
int tiempoInicio;
int penalizacionPistas = 0;
boolean temporizadorActivo = false;
char[] array = new char[6]; // Letras aleatorias
Random r = new Random();
boolean mostrarLetras = false; // Controla si se muestran las letras
int tiempoInicioLetras = 0; // Empiezan a aparecer las letras al pulsar start
boolean[] respuestasCorrectas = new boolean[6]; // Controla si la letra es correcta

ArrayList<Puntaje> ranking = new ArrayList<Puntaje>();
boolean mostrarRanking = false;
String nombreUsuario = "";
boolean introduciendoNombre = true;

void conectarBaseDatos() {
  try {
    Class.forName("org.sqlite.JDBC");
    Connection conn = DriverManager.getConnection("jdbc:sqlite:" + sketchPath("data/ranking"));
    stmt = conn.createStatement();
    println("Base de datos conectada correctamente.");
  } catch (Exception e) {
    println("Error al conectar con la base de datos:");
    e.printStackTrace();
    stmt = null;  // Asegurarse que no quede indefinido
  }
}

void conectarPuerto(){
  if (puertoSerie == null){
      puertoSerie = new Serial(this, Serial.list()[0],9600);  
  }
}

void setup() {
  
  println("Conectando a la base de datos...");
  conectarBaseDatos();
  printArray(Serial.list());
  conectarPuerto();
  while(puertoSerie.available() != 0 ){
    println(puertoSerie.readString());
  }
  
  size(1500, 900);
  if (!juegoIniciado) {
    PImage img;
    img = loadImage("portadagimp.png");
    background(img);
      

    // Inicializar el arreglo de letras con espacios en blanco
    for (int i = 0; i < letrasIngresadas.length; i++) {
      letrasIngresadas[i] = ' ';
    }
  } else {
    background(30, 58, 138);
    // Generar letras aleatorias
    resetPartida();
    // Inicia el temporizador
    tiempoRestante = tiempoInicial;
  }
}

void resetPartida(){
  for (int i = 0; i < array.length; i++) {
      array[i] = (char) (r.nextInt(26) + 97);
      letrasIngresadas[i] = '_'; // Inicialmente vacíos
      respuestasCorrectas[i] = false;
      mostrarRanking = false;
    }
    resultado = false;
}


void draw() {
  if (!juegoIniciado) {
    dibujarRectang();
    dibujarrectang2();
    Texto();
    TextoSombra();
  } else {
    background(240, 255, 255); // Redibujar fondo para limpiar pantalla
    dibujarLineas();
    actualizarTemporizador(true);
    dibujarBoton();
    dibujarBoton2();

    // Verificar si deben mostrarse las letras solo durante 3 segundos
    if (mostrarLetras && millis() - tiempoInicioLetras >= 3000) {  
      mostrarLetras = false; // Oculta las letras después de 3 segundos
    }

    dibujarCuadros();

    // Comprobar si todas las respuestas son correctas para detener el temporizador
    if (todasCorrectas()) {
      temporizadorActivo = false;

      if (!mostrarRanking) {
        int tiempoFinal = (tiempoInicial - tiempoRestante) + penalizacionPistas;  
        
        // Usar la variable nombreUsuario que se ha guardado en la portada
        ranking.add(new Puntaje(nombreUsuario, tiempoFinal));
        //try {
        String sql = "INSERT INTO ranking (nombre, tiempo) VALUES ('" + nombreUsuario + "', " + tiempoFinal + ")";
        //stmt.executeUpdate(sql);
        println("Resultado guardado en la base de datos: " + nombreUsuario + " - " + tiempoFinal);
        puertoSerie.write(nombreUsuario + ":" + tiempoFinal);//enviar al arduino
        //} catch (SQLException e) {
        //e.printStackTrace();
        //}

        Collections.sort(ranking);

        if (ranking.size() > 5) {
          ranking = new ArrayList<Puntaje>(ranking.subList(0, 5));
        }

        mostrarRanking = true;
      }

      // Mostrar ranking
      if (mostrarRanking) {
        textSize(30);
        fill(0);
        textAlign(LEFT, TOP);
        text("Ranking:", 1155, 10);

        for (int i = 0; i < ranking.size(); i++) {
          Puntaje p = ranking.get(i);
          String linea = (i + 1) + ". " + p.nombre + " - " + formatTime(p.tiempo);
          text(linea, 1155, 40 + i * 30);  // Mostrar el nombre y el tiempo
        }
      }
    }
  }
}


void dibujarRectang() {
  fill(220,220,220);
  rect(800, 400, 450, 100, 10);
}

void dibujarrectang2() {
  fill(250);
  rect(1200, 400, 100, 100, 10);
}

void Texto() {
  fill(190);
  textSize(35);
  text("ingresa tu usuario:", 800, 370, 50);
  textSize(110);
  text("→", 1215, 480, 100);
  fill(255);
  textSize(150);
  text("SpeeD", 155,350,20);
  textSize(150);
  text("MatX", 320,475,20);
  // Mostrar las letras ingresadas en el rectángulo grande
  fill(0);
  textSize(50);
  String textoIngresado = new String(letrasIngresadas);
  text(textoIngresado, 810, 470);
}

void TextoSombra() {
  fill(190);
  textSize(35);
  text("ingresa tu usuario:", 800, 370, 50);
  textSize(110);
  text("→", 1215, 480, 100);
  fill(200);
  textSize(150);
  text("SpeeD", 157,352,20);
  textSize(150);
  text("MatX", 322,477,20);
  // Mostrar las letras ingresadas en el rectángulo grande
  fill(0);
  textSize(50);
  String textoIngresado = new String(letrasIngresadas);
  text(textoIngresado, 810, 470);
}

void keyPressed() {
  if (!juegoIniciado) {
  if (key >= 'a' && key <= 'z') {
  for (int i = 0; i < letrasIngresadas.length; i++) {
    if (letrasIngresadas[i] == ' ') { // Encuentra el primer espacio vacío
      letrasIngresadas[i] = key;
      break;
    }
  }
  } else if (key == BACKSPACE) {
  // Eliminar la última letra ingresada
  for (int i = letrasIngresadas.length - 1; i >= 0; i--) {
    if (letrasIngresadas[i] != ' ') {
      letrasIngresadas[i] = ' ';
      break;
    }
  }
  }
  } else {    
  if (mostrarLetras) return;  // Impedir escribir mientras se muestran las letras (3 segundos iniciales)
  if (key == BACKSPACE) {
  // Eliminar la última letra incorrecta
  for (int i = letrasIngresadas.length - 1; i >= 0; i--) {
    if (letrasIngresadas[i] != '_' && !respuestasCorrectas[i]) {
      letrasIngresadas[i] = '_'; // Vacía el cuadro
      break; // Borra solo una letra incorrecta
    }
  }
  } else if (key >= 'a' && key <= 'z') {
  for (int i = 0; i < letrasIngresadas.length; i++) {
    if (letrasIngresadas[i] == '_') { // Encuentra el primer espacio vacío
      letrasIngresadas[i] = key;
      respuestasCorrectas[i] = (letrasIngresadas[i] == array[i]); // Compara con la original
      break; // Solo escribe en un cuadro a la vez
    }
  }
  }
  }
}

void iniciarJuego() {
  juegoIniciado = true;
  introduciendoNombre = false;
  resetPartida();
  tiempoRestante = tiempoInicial;
}


void mousePressed() {
 if (!juegoIniciado) {
 if (mouseX > 1200 && mouseX < 1300 && mouseY > 400 && mouseY < 500) {
  // Guardar nombre antes de iniciar juego
  nombreUsuario = new String(letrasIngresadas).trim();
  iniciarJuego();
  
  juegoIniciado = true;
  introduciendoNombre = false;
  setup(); // Reiniciar la configuración para el juego
     }
} else {
    if (mouseX > 0 && mouseX < 575 && mouseY > 800 && mouseY < 900) {
      tiempoInicio = millis();
      tiempoRestante = tiempoInicial = 60;
      temporizadorActivo = true;
      mostrarLetras = true;
      tiempoInicioLetras = millis();
      
     resetPartida();
     
    } else if (mouseX > 585 && mouseX < 1100 && mouseY > 800 && mouseY < 900) {
      tiempoInicio -= 10*1000;
      actualizarTemporizador(false);
      mostrarLetras = true;
      tiempoInicioLetras = millis();

    }
  }

}

// Dibujar líneas separadoras
void dibujarLineas() {
  stroke(0);
  line(1150, 0, 1150, 900); // Línea vertical
  line(1150, 300, 0, 300);  // Línea horizontal
}

// Dibujar cuadros y letras
void dibujarCuadros() {
  int tamano = 100;
  int espacio = 50;
  int cantidadCubos = 6;
  int startX = (1150 - (cantidadCubos * tamano + (cantidadCubos - 1) * espacio)) / 2;
  int startY = 360;

  int index = 0;
  textSize(40);
  textAlign(CENTER, CENTER);

  for (int j = 0; j <1; j++) {
  for (int i = 0; i < cantidadCubos; i++) {
    float x = startX + i * (tamano + espacio);
    float y = startY + j * (tamano + espacio);
    
    // Cambiar color si la letra ingresada es correcta
    if (respuestasCorrectas[index]) {
      fill(0, 255, 0); // Verde si es correcta
    } else {
      fill(255); // Blanco si aún no se ha ingresado
    }

    stroke(0);
    rect(x, y, tamano, tamano, 10);

    // Dibujar letras (si están dentro de los primeros 3 segundos)
    fill(0);
    if (mostrarLetras) {
      text(array[index], x + tamano / 2, y + tamano / 2);
    } else {
      text(letrasIngresadas[index], x + tamano / 2, y + tamano / 2);
    }

    index++;
  }
  }
}

// Función para actualizar y dibujar el temporizador
void actualizarTemporizador(boolean draw) {
  if (temporizadorActivo && draw) {
  int tiempoTranscurrido = (millis() - tiempoInicio) / 1000;
  tiempoRestante = tiempoInicial - tiempoTranscurrido;
  }

  fill(255, 245, 238);
  rect(0, 0, 1150, 350);

  fill(255, 138, 92);
  textSize(350);
  textAlign(CENTER, CENTER);

  if (tiempoRestante <= 0) {
  temporizadorActivo = false;
  tiempoRestante = 0;
  fill(255, 0, 0);
  textSize(100);
  text("¡Tiempo Terminado!", 1150 / 2, 300 / 2);
  } else {
  text(formatTime(tiempoRestante), 1150 / 2, 300 / 2);
  }
}

// Dibujar los botones
void dibujarBoton() {
  fill(245, 245, 220);
  rect(15, 780, 550, 100, 10);
  fill(25);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Iniciar", 0 + 575 / 2, 780 + 50);
}

void dibujarBoton2() {
  fill(255, 245, 238);
  rect(585, 780, 550, 100, 10);
  fill(0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Pista", 575 + 575 / 2, 780 + 50);
}

// Comprobar si todas las respuestas son correctas
boolean todasCorrectas() {
  for (boolean correcta : respuestasCorrectas) {
  if (!correcta) {
    return false; // Si alguna es incorrecta, no se detiene el temporizador
  }
  }
  return true; // Si todas son correctas, detener temporizador
}

// Formatear tiempo en mm:ss
String formatTime(int segundos) {
  int minutos = segundos / 60;
  int seg = segundos % 60;
  return nf(minutos, 2) + ":" + nf(seg, 2);
}
