//http://192.168.0.106/
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
 #include <ESP8266mDNS.h>

MDNSResponder mdns;
// Replace with your network credentials
const char* ssid = "ORION";
const char* password = "orion3454";
 
ESP8266WebServer server(80);   //instantiate server at port 80 (http port)
String webPage = "";
//String message=" ";
//String message1=" ";
String message="disconnected";
String message1="connected";
String inString="";
String uid="";
String upw="";
String page = "";
String data= "";
String data1=" ";
String data2=" ";
String data3=" ";
String data4=" ";
//double data,data1; 


void response(){
  if(server.hasArg("veh_no")&&server.hasArg("ins_date")){ 

  //  inString=String("*"+ server.arg("veh_no") +"#"+ server.arg("ins_date"));

uid=String(server.arg("veh_no"));
   upw=String(server.arg("ins_date"));

    
   // Serial.println(inString);
//
//    Serial.println("^^");
//    Serial.println(uid);
//     Serial.println("<<");
//        Serial.println(upw);
//   Serial.println("??");

    
    
  } else {

  }




if ((uid=="admin")&&(upw=="1234"))
 
 {

  //Serial.println("id okkkkkk");
 
server.send(200, "text/html", "<center><h1>Official</h1><center><br><br><form  name='frm'  method='post' form action=\"prpu\"><p>Price/Unit <input type='text' name='ppu'>&nbsp;&nbsp;<button>SEND</button></a></p>&nbsp;&nbsp;</form><form  name='frm'  method='post' form action=\"adm\"><p>Load limit <input type='text' name='lm'>&nbsp;&nbsp;<button>SEND</button></a></p>&nbsp;&nbsp;</form><br/>RELAY  :&nbsp;&nbsp;<a href=\"disc\"><button>DISCONNECT</button></a>""&nbsp;&nbsp;<a href=\"con\"><button>CONNECT</button></a>");  

    delay(1000);



 }
 else
 {
  //Serial.println("id nott    okkkkkk");

 server.send(200, "text/html", "<center><h1>Login</h1><center><br><br><form  name='frm'  method='post' form action=\"U\"><p>userid <input type='text' name='veh_no'><br>password: <input type='password' name='ins_date'><br><br>&nbsp;&nbsp;<a href=\"S\"><button>SEND</button></a></p><br>Invalid user id or password");
    
    delay(1000);
 }
}


void response11(){
  if(server.hasArg("lm")){ 
    
    inString=String("*"+ server.arg("lm") +"#");
  //  uid=String(server.arg("lm"));


    
    Serial.println(inString);

//    Serial.println("@@");
//    Serial.println(uid);
//  
//   Serial.println("!!");

   server.send(200, "text/html", "<html><body>okkkkkkkkk</body></html>"); 

  } else {

  }
}



void price_unit(){
  if(server.hasArg("ppu")){ 
    
    inString=String("!"+ server.arg("ppu") +"?");
//    uid=String(server.arg("ppu"));
//
//
//    
  Serial.println(inString);
//
//    Serial.println("@@");
//    Serial.println(uid);
//  
//   Serial.println("!!");

   server.send(200, "text/html", "<html><body>lllllll</body></html>"); 

  } else {

  }
}



void un_lt(){
  if(server.hasArg("ul")){ 
    
    inString=String("$"+ server.arg("ul") +"%");
//    uid=String(server.arg("ul"));
//
//
//    
 Serial.println(inString);
//
//    Serial.println("@@");
//    Serial.println(uid);
//  
//   Serial.println("!!");

   

  } else {

  }



}













void conn1()
{

      inString=String('p');

    Serial.println(inString);
    server.handleClient();

}


void disc1()
{

      inString=String('q');

    Serial.println(inString);
    server.handleClient();

}




void response1()
{
  
    inString=String('p');
 
    Serial.println(inString);
    server.handleClient();

}
void response2()
{
 
    inString=String('q');
    Serial.println(inString);
    server.handleClient();
}

void response3()
{
 
   
    inString=String('r');

    Serial.println(inString);
    server.handleClient();

}

void response4()
{

   
    inString=String('s');

    Serial.println(inString);
    server.handleClient();

}
String midString(String str, String start, String finish)
{
  int locStart = str.indexOf(start);
  if (locStart==-1) return "";
  locStart += start.length();
  int locFinish = str.indexOf(finish, locStart);
  if (locFinish==-1) return "";
  return str.substring(locStart, locFinish);
}











 









void setup(void)
{

 String month ="";
  pinMode(A0, INPUT);
  
  delay(1000);
  Serial.begin(9600);
  WiFi.begin(ssid, password); //begin WiFi connection
  Serial.println("");
  
  // Wait for connection
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 // Serial.println("");
 // Serial.print("Connected to ");
 // Serial.println(ssid);
  if (mdns.begin("esp8266", WiFi.localIP())) {
    //Serial.println("MDNS responder started");
 // Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  }
  server.on("/", [](){
       page = "<h1><center>KSEB Billing system</center></h1><h2>CONSUMER 1 </h2><h3>Consumer number: "+String('12345')+"</h3><h3>Unit:"+String(data1)+"</h3><h3>Amount:"+String(data2)+"</h3><br><br>";
   
    page += " <form  name='frm'  method='post' form action=\"unl\"><p>unit limit <input type='text' name='ul'>&nbsp;&nbsp;<button>SEND</button></a></p>&nbsp;&nbsp;</form>";

     page += "<br><br>&nbsp;&nbsp;<a href=\"S\"><button>Admin Login</button></a>";
   server.send(200, "text/html", page);

  });
  server.on("/S", [](){


 server.send(200, "text/html", "<center><h1>Login</h1><center><br><br><form  name='frm'  method='post' form action=\"U\"><p>userid <input type='text' name='veh_no'><br>password: <input type='password' name='ins_date'><br><br>&nbsp;&nbsp;<a href=\"S\"><button>SEND</button></a></p>");
  
  
    delay(1000);
  });

  server.on("/T", [](){
    server.send(200, "text/html", page);

    response2();
    delay(1000);
  });


  
 server.on("/con", [](){ 
   server.send(200, "text/html", "<html><body><h1>connected</h1></body></html>");
   conn1();
    delay(1000);
  });


 server.on("/disc", [](){
    
   server.send(200, "text/html", "<html><body><h1>Disconnected</h1></body></html>");

    disc1();
    delay(1000);
  });



 server.on("/adm", [](){
    response11();
    delay(1000);
  });

 server.on("/prpu", [](){
    price_unit();
    delay(1000);
  });




server.on("/unl", [](){

    server.send(300, "text/html", page);

     //server.send(200, "text/html", "<html><body><h1>rrrrrrrrr</h1></body></html>");
   
    un_lt();
    delay(1000);
  });


  
  server.on("/U", [](){
  response();

    delay(1000);
  });
  server.on("/V", [](){
    server.send(200, "text/html", page);
   
    response4();
    delay(1000);
  });
  server.begin();

}
 
void loop()
{

server.handleClient();
 if(Serial.available()>0)
  {
   
      data=Serial.readString();

data1=midString( data, "*", "#" );
data2=midString( data, "#", "$" );

    page = "<h1><center>KSEB Billing system</center></h1><h2>CONSUMER 1 </h2><h3>Consumer number: "+String('12345')+"</h3><h3>Unit:"+String(data1)+"</h3><h3>Amount:"+String(data2)+"</h3><br><br>";
   
    page += " <form  name='frm'  method='post' form action=\"unl\"><p>unit limit <input type='text' name='ul'>&nbsp;&nbsp;<button>SEND</button></a></p>&nbsp;&nbsp;</form>";

     page += "<br><br>&nbsp;&nbsp;<a href=\"S\"><button>Admin Login</button></a>";
  

   server.send(200, "text/html", page);
      delay(30);
      //i++;
      server.handleClient();
     }


server.handleClient();

  
  server.handleClient();

}

///////////////////////////////




