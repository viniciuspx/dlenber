PFont font;
color fill_color;
color back_color;
Checkbox axis_box;
Checkbox grid_box;
Checkbox translation_box;
Checkbox rotation_box;
Checkbox scale_box;

String[] proj_strings = {
  "Cavaleira",
  "Cabinet",
  "Isometrica",
  "1 Ponto de Fuga",
  "2 Pontos de Fuga"
};

void init_gui () {
  fill_color = WHITE;
  back_color = BLACK;
  font = createFont("Arial", 14, true);

  axis_box = new Checkbox(26,270,"Mostrar eixos",0);
  grid_box = new Checkbox(26,300,"Mostrar piso",1);

  translation_box = new Checkbox(26,400,"Translacao",2);
  rotation_box    = new Checkbox(26,430,"Rotacao",3);
  scale_box       = new Checkbox(26,460,"Escalonamento",4);

  axis_box.check();
  grid_box.check();
  translation_box.check();
}

void render_gui () {
  print_menu ();
  print_checkboxes_label();

  axis_box.render();
  grid_box.render();

  translation_box.render();
  rotation_box.render();
  scale_box.render();
}

void print_menu () {
  int p = 0; // Projection.CAVALIER
  if (projection == Projection.CABINET)       p = 1;
  if (projection == Projection.ISOMETRIC)     p = 2;
  if (projection == Projection.PERSPECTIVE_1) p = 3;
  if (projection == Projection.PERSPECTIVE_2) p = 4;

  fill(255);
  rect(24,15,50,20);
  print_font(" Menu ",font,26,30,BLACK);

  String label = "";
  label += " QE,AD,WS: Transladar \n RY,FH,TG: Rotacionar \n";
  label += " UO,JL,IK: Escalonar (+,-: total) \n 1 - 5: Projecoes \n ";
  label += "0: Origem (0 = zero)\n ";
  label += "P: Incrementa Projecao \n\n";
  label += " Projecao atual: ";
  print_font(label,font,20,55,fill_color);
  print_font(proj_strings[p],font,135,208,YELLOW);
  print_font(".",font,22,30,fill_color);
  print_font("Transformacoes no Universo",font,22,360,fill_color);
  print_font("ZX,CV,BN",font,22,380,fill_color);
}

void print_checkboxes_label () {
  String label = "Checkboxes clicaveis !";
  print_font(label,font,25,250,fill_color);
}

class Checkbox {
  int id;

  int size;
  int x,y,w,h;
  boolean checked;
  color myColor;
  String label;

  Checkbox (int x, int y, String label, int id) {
    // This is an extreme example of "POG"...
    // ("Programacao Orientada a Gambiarra")
    this.id = id;

    this.size = 20;
    this.x = x;
    this.y = y;
    this.w = this.size;
    this.h = this.size;
    this.checked = false;
    this.myColor = fill_color;
    this.label = label;
  }

  void check () {
    this.checked = true;
  }

  void uncheck () {
    this.checked = false;
  }

  void toggle() {
    this.checked = !this.checked;
  }

  void render () {
    int x0 = this.x, y0 = this.y;
    int x1 = x0 + this.w, y1 = y0;
    int x2 = x1, y2 = y1 + this.h;
    int x3 = x0, y3 = y2;

    lin_bres(x0,y0,x1,y1,this.myColor);
    lin_bres(x1,y1,x2,y2,this.myColor);
    lin_bres(x2,y2,x3,y3,this.myColor);
    lin_bres(x3,y3,x0,y0,this.myColor);

    print_font(
      this.label,font,
      this.x + this.size + (int)((float)this.size/2.0f),
      this.y + (int)((float)this.size/2.0f) + (int)((float)this.size/4.0f),
      fill_color
    );
    if (this.checked) {
      lin_bres(x0,y0,x2,y2,this.myColor);
      lin_bres(x1,y1,x3,y3,this.myColor);
    }
  }

  // This will not be pretty...
  // Research is being done to make it pretty !
  // (i.e., how to bind an action to an event ?...)
  void listen (int mousex, int mousey, Universe universe) {
    boolean insidex = mousex > this.x && mousex < this.x + this.w;
    boolean insidey = mousey > this.y && mousey < this.y + this.h;
    if (insidex && insidey) {
      // Axis box
      if (this.id == 0) {
        this.toggle();
        universe.toggleShowAxis();
      }
      // Grid box
      if (this.id == 1) {
        this.toggle();
        universe.toggleShowGrid();
      }
      // Translation box
      if (this.id == 2) {
        // this.toggle();
        // universe.toggleTranslateUniverse();
        if (!this.checked) {
          this.checked = true;
          rotation_box.checked = false;
          scale_box.checked = false;
          universe.translateUniverse = true;
          universe.rotateUniverse = false;
          universe.scaleUniverse = false;
        }
      }
      // Rotation box
      if (this.id == 3) {
        // this.toggle();
        // universe.toggleRotateUniverse();
        if (!this.checked) {
          this.checked = true;
          translation_box.checked = false;
          scale_box.checked = false;
          universe.translateUniverse = false;
          universe.rotateUniverse = true;
          universe.scaleUniverse = false;
        }
      }
      // Scale box
      if (this.id == 4) {
        // this.toggle();
        // universe.toggleScaleUniverse();
        if (!this.checked) {
          this.checked = true;
          translation_box.checked = false;
          rotation_box.checked = false;
          universe.translateUniverse = false;
          universe.rotateUniverse = false;
          universe.scaleUniverse = true;
        }
      }
    }
  }
}
