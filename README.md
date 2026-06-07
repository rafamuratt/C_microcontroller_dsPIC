# dsPIC30F4013 16x2 LCD 

Control a generic 16x2 LCD with the microcontroller dsPIC30F4013 (in 4 bits mode to save IOs) using IDE's LCD library.

---

## 🛠 Hardware Stack  

* **Microcontroller:** dsPIC30F4013 
* **HMI:** 16x2 LCD (4-bit mode)
* **Communication:** GPIO / Parallel Interface for LCD 
* **IDE:** MiKroC Pro for dsPIC  

---

## 📂 Project Structure

```
/MikroC Pro for dsPIC.zip -  Contains all IDE configuration and intermediate files. A copy of main C file is available in the main folder for easier visibility.
```

---

## ⚙ Operational Flow  

Reads analog input signal and display its value (as % in the 1st line and as 16 columns bargraph in the second, using with custom character). 
It also send the readed data over UART serial connection.

UI example:

Level: 50%
█ █ █ █ █ █ █ █ 

Detais on https://murat-tech.eu/

---

## 📜 License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).  
See the full license text at: https://www.gnu.org/licenses/gpl-3.0.html.

---

☕ If this project is helpful for your application, please consider supporting:<br> 
https://www.paypal.com/donate/?hosted_button_id=8S8BJ9TT368VN  

Built by **rafamuratt**: https://murat-tech.eu/  
Murat-Tech Channel: https://www.youtube.com/@Murat-TechChannel-EN

