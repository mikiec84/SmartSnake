
float globalMutationRate = 0.1;
boolean showAll = true;
Population p = new Population();
boolean stop = false;
boolean showSpecific = false;
int snakeIndex = -1;
int currentCSV;
DisposeHandler dh;
Table t = new Table();

void setup() {
  dh = new DisposeHandler(this);
  frameRate(15);
  size(1200, 800);
  createTable();
}

void draw() {
  background(150);
  drawData();
  if (!showSpecific)
    p.show();
  else
    p.showSpecific(snakeIndex);
  if (!stop)
    p.update();
}

void drawData() {
  fill(0);
  line(400, 0, 400, 800);
  textSize(25);
  text("Generation #: " + p.generations(), 10, 100);
  text("Highest score: " + p.globalBest(), 10, 150);
  text("mutation Rate: " + nf(globalMutationRate, 0, 2), 10, 200);
  textSize(10);
  text("Instructions:", 10, 550);
  text("' '  - toggle show all", 10, 570);
  text("+ - increase mutation rate", 10, 590);
  text("- - decrease mutation rate", 10, 610);
  text("s - stop all snakes from moving", 10, 630);
  text("r - generate a new population", 10, 650);
}

void keyPressed() {
  switch(key){
   case ' ':
     if (!showSpecific)
       showAll = !showAll;
     return;
   case '+':
     globalMutationRate += 0.01;
     if (globalMutationRate > 1) // mutation rate cannot go beyond 1
       globalMutationRate = 1;
     return;
   case '-':
     globalMutationRate -= 0.01;
     if (globalMutationRate < 0) // mutation rate cannot be lower than 0
       globalMutationRate = 0;
     return;
   case 'r':
     p = new Population();
     return;
   case 's':
     stop = !stop;
     return;
  }
}

void mousePressed() {
  if (mouseX > 400 && !showSpecific) {
    snakeIndex = 10 * (mouseY / 80) + (mouseX - 400) / 80;
    showAll = false;
    showSpecific = true;
  } else if (showSpecific) {
    showSpecific = false;
    showAll = true;
  }
}

void createTable() {
  t.addColumn("Snake");
  for (int i = 0; i < 100; ++i) {
    TableRow tr = t.addRow();
    tr.setString(0, "Snake #" + (i + 1));
  }
  TableRow tr = t.addRow();
  tr.setString(0, "Average");
}

String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    return null;
  }
}

public class DisposeHandler {
   
  DisposeHandler(PApplet pa)
  {
    pa.registerMethod("dispose", this);
  }
   
  public void dispose()
  {      
    String path = sketchPath() + "/data";
    String[] filenames = listFileNames(path);
    currentCSV = filenames == null ? 1 : filenames.length + 1;
    saveTable(t, "data/snakeState_" + currentCSV + ".csv");
  }
}