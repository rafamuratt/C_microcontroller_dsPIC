# C-Language 
Control a generic 16x2 LCD with the microcontroller dsPIC30F4013 (in 4 bits mode to save IOs) using IDE's LCD library.

IDE: MiKroC Pro for dsPIC - non registered version

Note: `MikroC Pro for dsPIC.zip`: Contains all IDE configuration and intermediate files.
A copy of main C file is available in the main folder for easier visibility.

Basic application: 
Reads analog input signal and display its value (as % in the 1st line and as 16 columns bargraph in the second, using with custom character). 
It also send the readed data over UART serial connection.

UI example:

Level: 50%
█ █ █ █ █ █ █ █ 

Detais on https://murat-tech.eu/
