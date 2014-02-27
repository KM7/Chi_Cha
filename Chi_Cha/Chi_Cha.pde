PrintWriter otmidi;
PrintWriter otboard;



import themidibus.*;
MidiBus myBus;
MidiBus OscBus;
int[][] board = new int[10][10];//Background Board
int[][] front = new int[10][10];//Front Midi Board
int[][] midimapping = new int[10][10];//Front Midi Board
int[][] colourarray = new int[4][4];//Front Midi Board
int[][] midiarray = new int[20][20];//Front Midi Board
int[][] autoplay = new int[100][100];//Front Midi Board
int[][][] database=new int[20][20][10];
int[][] guitarhara = new int[10][10];
int[] test=new int[20];
int nx=7;
int ny=7;
int nnx=3;
int nny=3;
int nnnx=7;
int nnny=10;
int ns=70;// the square size
//this is for the main chart axis
int x1=100;   
int y1=100;
int nsw=1;
int midin=0;
boolean ableton;

//this is for the chart paint 
int x2=200+7*ns;   
int y2=100;

//this is for keynote chart
int x3=200+7*ns;
int y3=100+5*ns/2;

int midistart=0;

int sw=1;//swich for pad control
int cs=0;




int cl=3;//colour as the velicity
int cll=48;//colour as the velicity for the front
int clr=64;//clear color
int n=0;
int k1=0;
int k2=0;
int[][] cc = new int[12][12];

void setup() {
  
for ( int f=0;f<=10;f=f+1){
test[f]=0;

  
 
} 
  
size(1000+ns,1000);
MidiBus.list();
myBus = new MidiBus(this, "Launchpad S", "Launchpad S");
OscBus = new MidiBus(this, "", "Arduino");
n=0;

//Board colour array info reading
reset();

LoadBoard();

//midimapping 2d array info reading
Loadmidimapping();

loadcolour();

Loadguitarhara();


loadmidilist();
myBus.sendNoteOn(0, 16*(sw-1)+8, cll);
}


void draw(){
  
if (ableton){

//draw the main loop  
for ( int f=0;f<=nx+1;f=f+1){
line (x1+f*ns,y1,x1+f*ns,y1+(nx+1)*ns);
}
for ( int f=0;f<=ny+1;f=f+1){
line (x1,y1+f*ns,x1+(ny+1)*ns,y1+f*ns);
}

//draw the colour arrangement


for ( int f=0;f<=nnx+1;f=f+1){
line (x2+f*ns/2,y2,x2+f*ns/2,y2+(nnx+1)*ns/2);
}
for ( int f=0;f<=nny+1;f=f+1){
line (x2,y2+f*ns/2,x2+(nny+1)*ns/2,y2+f*ns/2);
}

//draw the midi chart

for ( int f=0;f<=nnny;f=f+1){
for ( int t=0;t<=nnnx;t=t+1){
fill(219);
rect((x3+t*ns/2),(y3+f*ns/2),ns/2,ns/2);
fill(0);
textAlign(CENTER,CENTER);
text(str(midiarray[t][f]),(x3+t*ns/2),(y3+f*ns/2),ns/2,ns/2);
}
}





fill(219);
textAlign(LEFT);
rect(x2+5*ns/2,y2,3*ns/2,ns/2);
fill(255,67,136);
text("  Current Status",x2+5*ns/2,y2+ns/8,3*ns/2,ns/2);
colourfilltransfer(cl);
rect((x2+5*ns/2),(y2+ns/2),ns/2*3,ns/2*3);


fill(0);
textAlign(LEFT,TOP);
text(str(midin),x2+5*ns/2,(y2+ns/2),ns/2*3,ns/2*3);
textAlign(CENTER,CENTER);
text(nnc(midin),x2+5*ns/2,(y2+ns/2),ns/2*3,ns/2*3);
textAlign(RIGHT,BOTTOM);
text(str(cl),x2+5*ns/2,(y2+ns/2),ns/2*3,ns/2*3);











//colourshow for front
if (sw==8){

for ( int f=0;f<=4;f=f+1){
  
if (front[f][0]!=0){
  println(guitarhara[f][0]);
  midimapping[5][0]=guitarhara[f][0];
  midimapping[6][0]=guitarhara[f][1];
}

}


if ((front[4][0]!=0||front[3][0]!=0||front[2][0]!=0||front[1][0]!=0||front[0][0]!=0)==false){
  midimapping[5][0]=0;
  midimapping[6][0]=0;
  for ( int f=0;f<=127;f=f+1){
 OscBus.sendNoteOff(1,f,77);
}
}
}













if (cs==1){
  myBus.sendNoteOff(0, 16*(sw-1)+8, cll); 
  sw=nsw;
  myBus.sendNoteOn(0, 16*(sw-1)+8, cll); 
  cs=0;
}

for ( int f=1;f<=8;f=f+1){ 
if (front[8][f-1]!=0){
LoadBoard();
Loadmidimapping();
Loadautoplay();
reset();
  nsw=f;
  cs=1;
}
}

//press on situation
for ( int f=0;f<=ny;f=f+1){
for ( int t=0;t<=nx;t=t+1){
if (front[t][f]!=0){
colourfilltransfer(cll);
rect((x1+t*ns),(y1+f*ns),ns,ns);
myBus.sendNoteOn(0, f*16+t, cll); 

}
//press off situation at the same time printboard colour
if (front[t][f]==0){
colourfilltransfer(board[t][f]);
rect((x1+t*ns),(y1+f*ns),ns,ns);
textAlign(RIGHT, BOTTOM);
fill(0);





if (midimapping[t][f]!=0||board[t][f]!=0){
text(str(board[t][f]),(x1+t*ns),(y1+f*ns),ns,ns);
}


textAlign(CENTER, CENTER);
if (midimapping[t][f]!=0){
text(nnc(midimapping[t][f]),(x1+t*ns),(y1+f*ns),ns,ns);
}

textAlign(LEFT, TOP);

if (midimapping[t][f]!=0){
text(str(midimapping[t][f]),(x1+t*ns),(y1+f*ns),ns,ns);
}
myBus.sendNoteOn(0, f*16+t, board[t][f]);


}
}
}

//colour-array-marking place

for ( int f=0;f<=nny;f=f+1){
for ( int t=0;t<=nnx;t=t+1){
  
colourfilltransfer(colourarray[t][f]);
rect((x2+t*ns/2),(y2+f*ns/2),ns/2,ns/2);
text(colourarray[t][f],(x2+t*ns/2),(y2+f*ns/2));

}
}


for ( int f=0;f<=nny;f=f+1){
for ( int t=0;t<=nnx;t=t+1){
if ((mousePressed)&&(mouseX>(x2+t*ns/2))&&(mouseX<(x2+(t+1)*ns/2))&&(mouseY>(y2+f*ns/2))&&(mouseY<(y2+(f+1)*ns/2))){
cl=colourarray[t][f];}
  }
}

for ( int f=0;f<=ny;f=f+1){
for ( int t=0;t<=nx;t=t+1){
if ((mousePressed)&&(mouseX>(x1+t*ns))&&(mouseX<(x1+(t+1)*ns))&&(mouseY>(y1+f*ns))&&(mouseY<(y1+(f+1)*ns))){
board[t][f]=cl;
midimapping[t][f]=midin;

}
  }
}


for ( int f=0;f<=nnny;f=f+1){
for ( int t=0;t<=nnnx;t=t+1){
if ((mousePressed)&&(mouseX>(x3+t*ns/2))&&(mouseX<(x3+(t+1)*ns/2))&&(mouseY>(y3+f*ns/2))&&(mouseY<(y3+(f+1)*ns/2))){
midin=midiarray[t][f];}
  }
}

if (key == 'p' || key == 'P') {
saveinfo();
}

println(ableton);


}
}





void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  int a = pitch%16;
  int b = pitch/16;
  int c=pitch-127;
  front[a][b]=cll;//Front Midi Board
  if (midimapping[a][b]!=0&&midimapping[a][b]<=127){OscBus.sendNoteOn(1,midimapping[a][b],77); }
    if (midimapping[a][b]>127&&midimapping[a][b]!=999){
      int tt=midimapping[a][b]-128;
  OscBus.sendNoteOn(1,autoplay[test[tt]][tt],77);
  println(test[tt]);
    }
 if (midimapping[a][b]==999){
reset();
}

  }


void noteOff(int channel, int pitch, int velocity) {
  int a = pitch%16;
  int b = pitch/16;
  int c = pitch-126;
  front[a][b]=0;//Front Midi Board
  if (midimapping[a][b]!=0&&midimapping[a][b]<=127){OscBus.sendNoteOff(1,midimapping[a][b],77); }
  if (midimapping[a][b]>127&&midimapping[a][b]!=999){
int tt=midimapping[a][b]-128;
println(tt);

 OscBus.sendNoteOff(1,autoplay[test[tt]][tt],77);

     test[tt]=test[tt]+1;
    if (test[tt]==15){
     test[tt]=0;
}
}


}

void LoadBoard(){
String[] strLines = loadStrings(sw+"/board.txt");
for (int i = 0; i < strLines.length; i=i+1) {
  int[] xline = int(split(strLines[i], ',')); 
for (int c =0; c <=nx;c=c+1) {
board[c][i] =xline[c]; 
}
}
}



void Loadmidimapping(){
String[] strLines = loadStrings(sw+"/midimapping.txt");
for (int i = 0; i < strLines.length; i=i+1) {
  int[] xline = int(split(strLines[i], ',')); 
for (int c =0; c <=nx;c=c+1) {
midimapping[c][i] =xline[c]; 
}
}
}


void Loadautoplay(){
String[] strLines = loadStrings("autoplay.txt");
for (int i = 0; i < strLines.length; i=i+1) {
  int[] xline = int(split(strLines[i], ',')); 
for (int c =0; c <=14;c=c+1) {
autoplay[c][i] =xline[c]; 
}
}
}

void Loadguitarhara(){
String[] strLines = loadStrings("guitarhara.txt");
for (int i = 0; i < strLines.length; i=i+1) {
  int[] xline = int(split(strLines[i], ',')); 
for (int c =0; c <=5;c=c+1) {
guitarhara[c][i] =xline[c]; 
}
}
}








void colourfilltransfer(int a){
  if (a==1){fill(219,159,157);}
else if (a==2){fill(219,93,88);}
else if (a==3){fill(220,30,0);}
else  if (a==16){fill(155,216,157);}
else  if (a==17){fill(228,199,159);}
else  if (a==18){fill(219,159,157);}
else  if (a==19){fill(251,98,0);}
else  if (a==32){fill(81,214,87);}
else  if (a==33){fill(222,201,93);}
else  if (a==34){fill(238,180,86);}
else  if (a==35){fill(252,158,0);}
else  if (a==48){fill(0,213,0);}
else  if (a==49){fill(201,185,0);}
else  if (a==50){fill(229,179,0);}
else  if (a==51){fill(248,161,0);}
else {fill(219,219,219);} 
}

void loadcolour(){
for ( int f=0;f<=3;f=f+1){
for ( int t=0;t<=3;t=t+1){
  colourarray[t][f]=f*16+t;
}
}
} 

void loadmidilist(){
  int n=midistart;
for ( int f=0;f<=nnny;f=f+1){
for ( int t=0;t<=nnnx;t=t+1){
  midiarray[t][f]=n;
  n=n+1;
}
}
}


//NoteName converter stands for nnc

String nnc(int c){ 
  int k; // k for character
  int n; // n for number
  String in="error 1"; 
  String reta="error 2"; // reta for return
  
  k=c%12;
  n=c/12;
  
  if (c>=0&&k<=127){
  if(k==0){in="C";}
  if(k==1){in="C#";}
  if(k==2){in="D";}
  if(k==3){in="D#";}
  if(k==4){in="E";}
  if(k==5){in="F";}
  if(k==6){in="F#";}
  if(k==7){in="G";}
  if(k==8){in="G#";}
  if(k==9){in="A";}
  if(k==10){in="A#";}
  if(k==11){in="B";}
    reta=in+str(n);
  }
  
  if (c>127){
    reta="SPECIAL";
    
    
    
  }
  return reta;
  
}
  
  
  
void saveinfo(){
otboard = createWriter("board.txt");
otmidi = createWriter("midimapping.txt");
  for ( int f=0;f<=ny;f=f+1){
for ( int t=0;t<=nx;t=t+1){
otboard.print(board[t][f]+",");
otmidi.print(midimapping[t][f]+",");
if (t==nx){
otboard.println(board[t][f]);
otmidi.println(midimapping[t][f]);
}
}
}
  otboard.flush();  // Writes the remaining data to the file
  otboard.close();  // Finishes the file
  otmidi.flush();  // Writes the remaining data to the file
  otmidi.close();  // Finishes the file
}

void reset(){
  for ( int f=0;f<=10;f=f+1){
test[f]=0;
  }
for ( int f=0;f<=255;f=f+1){
 OscBus.sendNoteOff(1,f,77);
}
  
 
  
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println(number);
  
for ( int f=104;f<=111;f=f+1){
if (f!=110){
 ableton = false; 
}
if (number==110){
 ableton = true; 
}
}
}







