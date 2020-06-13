#include <TimerOne.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>
#include <stdio.h>
#include <stdlib.h>
#include <WProgram.h>
#include <Wire.h>
#include <DS1307.h>
#include <NewSoftSerial.h>
NewSoftSerial web_esp(8,9);

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(2, 3, 4, 5, 6, 7);

///////////////////////////////////////////////////////////

 

const int Relay= 12;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////


char flag=0;
int totalconaddrs = 30;
float cur=0;
float p=0;

float newcurrt=0;
float newvolt=0;
float avgcurr=0;
float avgvolt=0;
float mapcur=0;
float newpower=0;
float newpower1=0;
float mapcur1=0;
float mapvolt1=0;
int avglgt;

int i,j;

int current=0;
int voltage=0;
void algorithm();
volatile float kwh=0.000277;

 char totalconsumptionarray[6],totalconsumptionreadarray[7];
float totalpower,totalconsumption,totalconsumptionprev,consumption;
long int newtotal,sendtotalconsumption,sendnewpower;
 
char newpowerarray[7],consumptionarray[7];
//float  totalconsumption_n;
float unitamount;

//char unitamount_ar[7];
//char totalconsumption_ar[7];

char unitamount_ar[7];
char totalconsumption_ar[7];



//char ll[7]="10";
//char ul[7]="25";
//char ppu[7]="1.5"; 



char ll[7];
char ul[7];
char ppu[7]; 



int con_flag=0;
float ul_n;
float ll_n;
float ppu_n;
 
int month;
int minutes;
int seconds; 
int hr;
int tm;

 
int addr; 
 
 
 
 
      
void setup() 
  {
       lcd.begin(16, 2);
       lcd.print("Smart Meter");
       pinMode(Relay,OUTPUT);
       
       Serial.begin(9600);
       web_esp.begin(9600);
       digitalWrite(Relay,HIGH);
       
         RTC.stop();
        RTC.set(DS1307_SEC,35);        //set the seconds
        RTC.set(DS1307_MIN,34);     //set the minutes
        RTC.set(DS1307_HR,12);       //set the hours
        RTC.set(DS1307_DOW,1);       //set the day of the week
        RTC.set(DS1307_DATE,29);       //set the date
        RTC.set(DS1307_MTH,1);        //set the month
        RTC.set(DS1307_YR,17);         //set the year
        RTC.start();
   
       
       
        
        
       delay(1000);
       EEPROM.write(totalconaddrs,'*');
       Timer1.initialize(1000000);
       Timer1.attachInterrupt(callback);
       Serial.flush();



addr=0;
i=0;
ll[i]=EEPROM.read(addr);
       while(ll[i]!='*')
         {  
            addr++;i++;
            ll[i]=EEPROM.read(addr);   
       }
 ll[i]='\0';



addr=10;
i=0;
ul[i]=EEPROM.read(addr);
       while(ul[i]!='*')
         {  
            addr++;i++;
            ul[i]=EEPROM.read(addr);   
       }
 ul[i]='\0';
 
 
 
 addr=20;
i=0;
ppu[i]=EEPROM.read(addr);
       while(ppu[i]!='*')
         {  
            addr++;i++;
            ppu[i]=EEPROM.read(addr);   
       }
 ppu[i]='\0';
 

              
       
  }
void loop() 
  {


ll_n=atof(ll);
ul_n=atof(ul);
ppu_n=atof(ppu);

 lcd.clear();
       lcd.print("Lt:");
 lcd.print(ll_n);
     lcd.print("ut:");
     lcd.print(ul_n);
     lcd.setCursor(0,1);
      lcd.print("p/u:");
     lcd.print(ppu_n);
      webdata_check();
     delay(1000);
     webdata_check();
      algorithm(); 
      webdata_check();
      timedisplay();
      delay(1000);
       webdata_check();  
unitamount=totalconsumption*ppu_n;
              

      web_esp.print("*")   ; 
     web_esp.print(totalconsumption)   ;      
      web_esp.print("#")   ; 
      
       web_esp.print(unitamount)   ;  
        
        web_esp.print("$") ;
        
     if(newpower1>ll_n)
    {
      
        digitalWrite(Relay,LOW);
              lcd.clear();
      lcd.print("relay off");
              delay(500);  
              
    } 
   if((totalconsumption>ul_n)&&(con_flag==0))
    {
     msgsent(); 
     con_flag=1;
    }      
        
      

}


void algorithm()
   {
       for(i=0;i<10;i++)
          {
             
              newvolt=0;
              newcurrt=0;
           
              for(j=0;j<10;j++)
                 {
                     current=analogRead(A0);
                     delay(1);
                     newcurrt=newcurrt+current;      
                     voltage=analogRead(A1);
                     delay(1);
                     newvolt=newvolt+voltage;
                     
                  
                
                     
                  
                 }
        
               avgcurr=newcurrt*0.1; 
               mapcur1=map(avgcurr,0,1023,0,5550);
               avgvolt=newvolt*0.1;
               mapvolt1=map(avgvolt,0,1023,0,500);
               mapcur=mapcur1*.001;
               newpower=mapcur*mapvolt1;//*theta;
               newpower1=newpower+newpower1;
          
         }
 
      newpower1=newpower1*.1;
      newpower1=newpower1*.001;
    
      
     
      lcd.clear();
      lcd.print("Curr=");
      lcd.print(mapcur1);
      lcd.print("mA");
      lcd.setCursor(0,1);
      lcd.print("volt=");
      lcd.print(mapvolt1);
      lcd.print("V");
      delay(1000); 
     
      lcd.clear();
      lcd.print("newpower=");
      lcd.print(newpower1);
      lcd.print("KW");
      lcd.setCursor(0,1);
      lcd.print("Con=");
      lcd.print(totalconsumption);
      lcd.print("KWh");
      delay(1000);  

      
}

void callback(void)
   {  
        totalconsumption=consumptioneepromread();
        consumption=newpower1*kwh;
        totalconsumption=totalconsumption+consumption;
        newtotal=totalconsumption*100;
        itoa(newtotal,totalconsumptionarray,10);
        i=0;totalconaddrs=30;
        while(totalconsumptionarray[i]!='\0')
          {  
              EEPROM.write(totalconaddrs,totalconsumptionarray[i]);
                        
              totalconaddrs++;i++;
              
              delay(10);
          }
        EEPROM.write(totalconaddrs,'*');
         
   }


float consumptioneepromread(void)
   {
       totalconaddrs=30;i=0;
       int conversionvar=0;
       float conversionreturn;
       totalconsumptionreadarray[i]=EEPROM.read(totalconaddrs);
       while(totalconsumptionreadarray[i]!='*')
         {  
            totalconaddrs++;i++;
            totalconsumptionreadarray[i]=EEPROM.read(totalconaddrs);   
         
            
            
          }
       conversionvar=atoi(totalconsumptionreadarray);
       conversionreturn=conversionvar*.01;
       return(conversionreturn);

   }  
  
  
  
  
  
  
  
  
  
  void timedisplay(void)
    {
      
           hr=RTC.get(DS1307_HR,true);
          lcd.clear();
          lcd.print(RTC.get(DS1307_HR,true)); //read the hour and also update all the values by pushing in true
          lcd.print(":");
          minutes=RTC.get(DS1307_MIN,false); 
          lcd.print(minutes);//read minutes without update (false)
          lcd.print(":");              // some space for a more happy life
          seconds=RTC.get(DS1307_SEC,false);
          lcd.print(seconds);
          lcd.setCursor(0,1);
          lcd.print(RTC.get(DS1307_DATE,false));//read date
          lcd.print("/");
          lcd.print(RTC.get(DS1307_MTH,false));//read month
          lcd.print("/");
          lcd.print(RTC.get(DS1307_YR,false)); //read year 
          //lcd.setCursor(0,1);
     
      tm=(hr*100)+minutes; 
     
          
  
    }
  
  
  
  
  
  
  
  void webdata_check()
{

if(web_esp.available()>0)
          {
              char ch = web_esp.read();
              if(ch=='q')
                  {
        digitalWrite(Relay,LOW);
              lcd.clear();
      lcd.print("relay off");
              delay(500);           
                  }
              else if(ch=='p')
                  {
                  
 digitalWrite(Relay,HIGH);
              lcd.clear();
      lcd.print("relay on");
              delay(500); 
     
                      
                      
                      
                  }
                  
            else if(ch=='*')
                  {
      ch=web_esp.read();
     i=0;
     while(ch!='#')
    {
      delay(10);
      ll[i]=ch;
      lcd.clear();
      lcd.print(ch);
      ch=web_esp.read();
      i++;
    }

    ll[i]='\0';  
    
    j=0;
    for(i=0;ll[i]!='\0';i++)
    {
    
      EEPROM.write(j, ll[i]);
      j++;
    }
       EEPROM.write(j,'*');
    
     lcd.clear();
      lcd.print(ll);
              delay(500);                    
                  }       
                  
      else if(ch=='$')
                  {
      ch=web_esp.read();
     i=0;
     while(ch!='%')
    {
      delay(10);
      ul[i]=ch;
      ch=web_esp.read();
      i++;
    }

    ul[i]='\0';  
    
    
      j=10;
    for(i=0;ul[i]!='\0';i++)
    {
    
      EEPROM.write(j, ul[i]);
      j++;
    }
       EEPROM.write(j,'*');
    
    
    
    con_flag=0;
     lcd.clear();
      lcd.print(ul);
              delay(500);                    
                  }       
                    
    
     else if(ch=='!')
                  {
      ch=web_esp.read();
     i=0;
     while(ch!='?')
    {
      delay(10);
      ppu[i]=ch;
      ch=web_esp.read();
      i++;
    }

    ppu[i]='\0'; 
   
   
     j=20;
    for(i=0;ppu[i]!='\0';i++)
    {
    
      EEPROM.write(j, ppu[i]);
      j++;
    }
       EEPROM.write(j,'*');
    
   
    
    
     lcd.clear();
      lcd.print(ppu);
              delay(500);                    
                  }       
                  
    
                  
           
           
            web_esp.flush();      
                
           }
     
}



void msgsent(void)
   {
       Serial.print("AT\r");
       delay(1000);
       Serial.print("AT+CMGF=1\r");
       delay(1000);
         Serial.print("AT+CMGS=\"9746829900\"\r");
         delay(1000);
         
         Serial.print("Limit reached");
                        delay(400);
        Serial.write(0x1A); 
         
                                               
           }

   


  
