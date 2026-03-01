
_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;Vol_Ctrl_UART_dsPIC30F4013.c,40 :: 		void main(){
;Vol_Ctrl_UART_dsPIC30F4013.c,41 :: 		ADPCFG  = 0xFFFB;                                                          // 1111 1111 1111 1011 only AN2 (RB2) is analog
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#65531, W0
	MOV	WREG, ADPCFG
;Vol_Ctrl_UART_dsPIC30F4013.c,42 :: 		TRISB   = 0x000C;                                                          // 0000 1100 PORTB as output (RB3 & RB2 = input)
	MOV	#12, W0
	MOV	WREG, TRISB
;Vol_Ctrl_UART_dsPIC30F4013.c,43 :: 		LATB    = 0x0000;                                                          // init PORTB
	CLR	LATB
;Vol_Ctrl_UART_dsPIC30F4013.c,44 :: 		TRISF   = 0xFFF7;                                                          // 1111 1111 1111 0111 only U1TX (RF3, pin 25) is output
	MOV	#65527, W0
	MOV	WREG, TRISF
;Vol_Ctrl_UART_dsPIC30F4013.c,45 :: 		LATF    = 0x0000;
	CLR	LATF
;Vol_Ctrl_UART_dsPIC30F4013.c,47 :: 		ADC1_Init();
	CALL	_ADC1_Init
;Vol_Ctrl_UART_dsPIC30F4013.c,48 :: 		UART1_Init(9600);
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Vol_Ctrl_UART_dsPIC30F4013.c,50 :: 		Lcd_Init();
	CALL	_Lcd_Init
;Vol_Ctrl_UART_dsPIC30F4013.c,51 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;Vol_Ctrl_UART_dsPIC30F4013.c,52 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOV.B	#12, W10
	CALL	_Lcd_Cmd
;Vol_Ctrl_UART_dsPIC30F4013.c,55 :: 		customChar();
	CALL	_customChar
;Vol_Ctrl_UART_dsPIC30F4013.c,56 :: 		Lcd_Out(1,4,"Level:");
	MOV	#lo_addr(?lstr1_Vol_Ctrl_UART_dsPIC30F4013), W12
	MOV	#4, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;Vol_Ctrl_UART_dsPIC30F4013.c,58 :: 		while(1){
L_main0:
;Vol_Ctrl_UART_dsPIC30F4013.c,59 :: 		adcRaw = ADC1_Get_Sample(2);
	MOV	#2, W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _adcRaw
;Vol_Ctrl_UART_dsPIC30F4013.c,60 :: 		adcLevel = ((unsigned long)adcRaw*100)/4095;
	CLR	W1
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	#4095, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV	W0, _adcLevel
;Vol_Ctrl_UART_dsPIC30F4013.c,61 :: 		IntToStr(adcLevel, txtPrint);
	MOV	#lo_addr(_txtPrint), W11
	MOV	W0, W10
	CALL	_IntToStr
;Vol_Ctrl_UART_dsPIC30F4013.c,62 :: 		trimmed = Ltrim(txtPrint);                                            // Removes the leading spaces "  100" -> "100"
	MOV	#lo_addr(_txtPrint), W10
	CALL	_Ltrim
	MOV	W0, _trimmed
;Vol_Ctrl_UART_dsPIC30F4013.c,64 :: 		Lcd_Out(1,11, trimmed);
	MOV	W0, W12
	MOV	#11, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;Vol_Ctrl_UART_dsPIC30F4013.c,65 :: 		Lcd_Chr_CP('%');
	MOV.B	#37, W10
	CALL	_Lcd_Chr_CP
;Vol_Ctrl_UART_dsPIC30F4013.c,66 :: 		Lcd_Chr_CP(' ');                                                      // Extra space to erase the old char (eg. '%')
	MOV.B	#32, W10
	CALL	_Lcd_Chr_CP
;Vol_Ctrl_UART_dsPIC30F4013.c,68 :: 		WordToStr(adcRaw, txt);
	MOV	#lo_addr(_txt), W11
	MOV	_adcRaw, W10
	CALL	_WordToStr
;Vol_Ctrl_UART_dsPIC30F4013.c,69 :: 		UART1_Write_Text(txt);                                                // Send raw ADC data via UART1 (TX @ pin 25)
	MOV	#lo_addr(_txt), W10
	CALL	_UART1_Write_Text
;Vol_Ctrl_UART_dsPIC30F4013.c,71 :: 		barGraph();
	CALL	_barGraph
;Vol_Ctrl_UART_dsPIC30F4013.c,72 :: 		}
	GOTO	L_main0
;Vol_Ctrl_UART_dsPIC30F4013.c,74 :: 		}
L_end_main:
	POP	W12
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_barGraph:

;Vol_Ctrl_UART_dsPIC30F4013.c,79 :: 		void barGraph(){
;Vol_Ctrl_UART_dsPIC30F4013.c,82 :: 		barLength = (adcRaw >> 8) + 1;                                             // 4095/ 256 = 16 to match adcRaw data with 16 columns of LCD
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	_adcRaw, W0
	LSR	W0, #8, W0
; barLength start address is: 4 (W2)
	ADD	W0, #1, W2
;Vol_Ctrl_UART_dsPIC30F4013.c,85 :: 		for(col = 1; col <= 16; col++) {
; col start address is: 0 (W0)
	MOV	#1, W0
; col end address is: 0 (W0)
	MOV	W0, W3
L_barGraph2:
; col start address is: 6 (W3)
; barLength start address is: 4 (W2)
; barLength end address is: 4 (W2)
	CP	W3, #16
	BRA LE	L__barGraph13
	GOTO	L_barGraph3
L__barGraph13:
; barLength end address is: 4 (W2)
;Vol_Ctrl_UART_dsPIC30F4013.c,86 :: 		if(col <= barLength) {
; barLength start address is: 4 (W2)
	CP	W3, W2
	BRA LE	L__barGraph14
	GOTO	L_barGraph5
L__barGraph14:
;Vol_Ctrl_UART_dsPIC30F4013.c,87 :: 		Lcd_Chr(2, col, 0);                                              // progressive bar: print the custom character stored in Slot 0
	CLR	W12
	MOV	W3, W11
	MOV	#2, W10
	CALL	_Lcd_Chr
;Vol_Ctrl_UART_dsPIC30F4013.c,88 :: 		} else {
	GOTO	L_barGraph6
L_barGraph5:
;Vol_Ctrl_UART_dsPIC30F4013.c,89 :: 		Lcd_Chr(2, col, ' ');                                            // regressive bar: print a space to erase any old blocks
	MOV.B	#32, W12
	MOV	W3, W11
	MOV	#2, W10
	CALL	_Lcd_Chr
;Vol_Ctrl_UART_dsPIC30F4013.c,90 :: 		}
L_barGraph6:
;Vol_Ctrl_UART_dsPIC30F4013.c,85 :: 		for(col = 1; col <= 16; col++) {
	INC	W3
;Vol_Ctrl_UART_dsPIC30F4013.c,91 :: 		}
; barLength end address is: 4 (W2)
; col end address is: 6 (W3)
	GOTO	L_barGraph2
L_barGraph3:
;Vol_Ctrl_UART_dsPIC30F4013.c,92 :: 		}
L_end_barGraph:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _barGraph

_customChar:

;Vol_Ctrl_UART_dsPIC30F4013.c,97 :: 		void customChar() {
;Vol_Ctrl_UART_dsPIC30F4013.c,100 :: 		Lcd_Cmd(64);                                                                // 0x40h: Address for the first custom character slot
	PUSH	W10
	MOV.B	#64, W10
	CALL	_Lcd_Cmd
;Vol_Ctrl_UART_dsPIC30F4013.c,101 :: 		for (i = 0; i <= 7; i++)
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_customChar7:
; i start address is: 4 (W2)
	CP.B	W2, #7
	BRA LEU	L__customChar16
	GOTO	L_customChar8
L__customChar16:
;Vol_Ctrl_UART_dsPIC30F4013.c,102 :: 		Lcd_Chr_CP(character[i]);                                               // build the custom character
	ZE	W2, W1
	MOV	#lo_addr(customChar_character_L0), W0
	ADD	W0, W1, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W10
	CALL	_Lcd_Chr_CP
;Vol_Ctrl_UART_dsPIC30F4013.c,101 :: 		for (i = 0; i <= 7; i++)
	INC.B	W2
;Vol_Ctrl_UART_dsPIC30F4013.c,102 :: 		Lcd_Chr_CP(character[i]);                                               // build the custom character
; i end address is: 4 (W2)
	GOTO	L_customChar7
L_customChar8:
;Vol_Ctrl_UART_dsPIC30F4013.c,104 :: 		Lcd_Cmd(_LCD_RETURN_HOME);
	MOV.B	#2, W10
	CALL	_Lcd_Cmd
;Vol_Ctrl_UART_dsPIC30F4013.c,105 :: 		}
L_end_customChar:
	POP	W10
	RETURN
; end of _customChar
