/*
PIC dsPIC30F413, external clock @20MHz
LCD Hitachi 16x2 HD44780 (4 bits display control)
Note: R/W bit is not controlled (permanentely grounded to write data on LCD only)
ADC read + barGraph with custom character + TX send via UART1
02/2026
*/

// Lcd module connections
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


/* -----------------------------------------------------------------------------*/
// Functions Prototypes
void barGraph();
void customChar();                                                              // Custom character (narrow filled rectangle)


/* -----------------------------------------------------------------------------*/
// Global variables
unsigned adcRaw, adcLevel;                                                      // 12 bits AD convertion
char txt[7], txtPrint[7];                                                       // string for UART transmission
char *trimmed;                                                                  // pointer to hold the % number with no blank spaces


/* -----------------------------------------------------------------------------*/
// Main Function
void main(){
     ADPCFG  = 0xFFFB;                                                          // 1111 1111 1111 1011 only AN2 (RB2) is analog
     TRISB   = 0x000C;                                                          // 0000 1100 PORTB as output (RB3 & RB2 = input)
     LATB    = 0x0000;                                                          // init PORTB
     TRISF   = 0xFFF7;                                                          // 1111 1111 1111 0111 only U1TX (RF3, pin 25) is output
     LATF    = 0x0000;

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
          trimmed = Ltrim(txtPrint);                                            // Removes the leading spaces "  100" -> "100"
          
          Lcd_Out(1,11, trimmed);
          Lcd_Chr_CP('%');
          Lcd_Chr_CP(' ');                                                      // Extra space to erase the old char (eg. '%')
          
          WordToStr(adcRaw, txt);
          UART1_Write_Text(txt);                                                // Send raw ADC data via UART1 (TX @ pin 25)
          
          barGraph();
     }

}


/* -----------------------------------------------------------------------------*/

void barGraph(){
     int barLength;
     int col;
     barLength = (adcRaw >> 8) + 1;                                             // 4095/ 256 = 16 to match adcRaw data with 16 columns of LCD

     // Loop through all 16 columns of the LCD row
     for(col = 1; col <= 16; col++) {
          if(col <= barLength) {
               Lcd_Chr(2, col, 0);                                              // progressive bar: print the custom character stored in Slot 0
          } else {
               Lcd_Chr(2, col, ' ');                                            // regressive bar: print a space to erase any old blocks
          }
     }
}


/* -----------------------------------------------------------------------------*/
// Custom character (narrow filled rectangle)
void customChar() {
  const char character[] = {14,14,14,14,14,14,14,14};                           // custom character itself
  char i;
    Lcd_Cmd(64);                                                                // 0x40h: Address for the first custom character slot
    for (i = 0; i <= 7; i++) 
        Lcd_Chr_CP(character[i]);                                               // build the custom character
        
    Lcd_Cmd(_LCD_RETURN_HOME);
}



