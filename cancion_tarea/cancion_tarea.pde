import processing.sound.*;

SoundFile cancion;
FFT fft;

int columnas = 16;
int tam = 40;
int filas;
float[] energia;
ArrayList<Cuadro>[] reja;
boolean lleno = false;

void setup() {
  size(640, 800);
  background(0);
  
  filas = height / tam;

  cancion = new SoundFile(this, "selfcare.mp3");
  cancion.play();

  fft = new FFT(this, columnas);
  fft.input(cancion);

  energia = new float[columnas];
  reja = (ArrayList<Cuadro>[]) new ArrayList[columnas];
  for (int i = 0; i < columnas; i++) {
    reja[i] = new ArrayList<Cuadro>();
  }
}

void draw() {
  background(0, 40);
  fft.analyze(energia);

  // Dibujar y actualizar cuadros fijos
  for (int i = 0; i < columnas; i++) {
    for (Cuadro c : reja[i]) {
      c.actualizarColor();
      c.dibujar();
    }
  }

  // Agregar nuevos cuadros si no está lleno
  if (!lleno && frameCount % 10 == 0) {
    agregarCuadro();
  }
}

// Agrega un cuadro en una columna aleatoria que aún tenga espacio
void agregarCuadro() {
  ArrayList<Integer> disponibles = new ArrayList<Integer>();
  for (int i = 0; i < columnas; i++) {
    if (reja[i].size() < filas) {
      disponibles.add(i);
    }
  }

  if (disponibles.isEmpty()) {
    lleno = true;
    return;
  }

  int col = disponibles.get(int(random(disponibles.size())));
  float x = col * tam + tam / 2;
  int nivel = reja[col].size();
  float y = height - tam / 2 - nivel * tam;

  Cuadro nuevo = new Cuadro(x, y, col);
  reja[col].add(nuevo);
}

class Cuadro {
  float x, y;
  int columna;
  color gris;

  Cuadro(float x_, float y_, int col_) {
    x = x_;
    y = y_;
    columna = col_;
  }

  void actualizarColor() {
    float g = map(energia[columna], 0, 0.3, 100, 255);
    gris = color(g);
  }

  void dibujar() {
    noFill();
    stroke(gris);
    strokeWeight(2);
    rectMode(CENTER);
    rect(x, y, tam, tam);
  }
}
