#line 1 "C:/Users/Rafamuratt/Documents/1Rafa/005 - Engenharia/1 - Estudos/001 Aulas/C WR Kits/Módulo 010/10.2 dsPIC/Vol_Ctrl_UART dsPIC30F4013/MikroC/Vol_Ctrl_UART_dsPIC30F4013.c"
#line 10 "C:/Users/Rafamuratt/Documents/1Rafa/005 - Engenharia/1 - Estudos/001 Aulas/C WR Kits/Módulo 010/10.2 dsPIC/Vol_Ctrl_UART dsPIC30F4013/MikroC/Vol_Ctrl_UART_dsPIC30F4013.c"
sbit LCD_RS at LATB0_bit;
sbit LCD_EN at LATB1_bit;
sbit LCD_D4 at LATB4_bit;
sbit LCD_D5 at LATB5_bit;
sbit LCD_D6 at LATB6_bit;
sbit LCD_D7 at LATB7_bit;

sbit LCD_RS_Direction at TRISB0_bit;
sbit LCD_EN_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;




void barGraph();
void customChar();




unsigned adcRaw, adcLevel;
char txt[7], txtPrint[7];
char *trimmed;




void main(){
 ADPCFG = 0xFFFB;
 TRISB = 0x000C;
 LATB = 0x0000;
 TRISF = 0xFFF7;
 LATF = 0x0000;

 ADC1_Init();
 UART1_Init(9600);

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 customChar();
 Lcd_Out(1,4,"Level:");

 while(1){
 adcRaw = ADC1_Get_Sample(2);
 adcLevel = ((unsigned long)adcRaw*100)/4095;
 IntToStr(adcLevel, txtPrint);
 trimmed = Ltrim(txtPrint);

 Lcd_Out(1,11, trimmed);
 Lcd_Chr_CP('%');
 Lcd_Chr_CP(' ');

 WordToStr(adcRaw, txt);
 UART1_Write_Text(txt);

 barGraph();
 }

}




void barGraph(){
 int barLength;
 int col;
 barLength = (adcRaw >> 8) + 1;


 for(col = 1; col <= 16; col++) {
 if(col <= barLength) {
 Lcd_Chr(2, col, 0);
 } else {
 Lcd_Chr(2, col, ' ');
 }
 }
}




void customChar() {
 const char character[] = {14,14,14,14,14,14,14,14};
 char i;
 Lcd_Cmd(64);
 for (i = 0; i <= 7; i++)
 Lcd_Chr_CP(character[i]);

 Lcd_Cmd(_LCD_RETURN_HOME);
}
