//+------------------------------------------------------------------+
//|                                                    MySQL-001.mq4 |
//|                                   Copyright 2014, Eugene Lugovoy |
//|                                        http://www.fxcodexlab.com |
//| Test connections to MySQL. Reaching limit (DEMO)                 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Eugene Lugovoy"
#property link      "http://www.fxcodexlab.com"
#property version   "1.00"
#property strict

#include <MQLMySQL.mqh>

string INI;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnInit()
{
 string Host, User, Password, Database, Socket; // database credentials
 int Port,ClientFlag;
 int DB1,DB2,DB3; // database identifiers

 
 // reading database credentials from INI file
 Host = "den1.mysql2.gear.host";
 User = "mysqlnewsea";
 Password = "Tw7E4Y~e_6nF";
 Database = "mysqlnewsea";
 Port     = 3306;
 Socket   = 0;
 ClientFlag = 0;  

 Print ("Host: ",Host, ", User: ", User, ", Database: ",Database);
 
 // open database connection
 Print ("Connecting...");
Comment ("Connecting...");
 
 DB1 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB1 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB1);}
 
 DB2 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB2 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB2);}

 DB3 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB3 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB3);}
 
 MySqlDisconnect(DB3);
 MySqlDisconnect(DB2);
 MySqlDisconnect(DB1);
 Print ("All connections closed. Script done!");
 Comment ("All connections closed. Script done!");
   
}
//+------------------------------------------------------------------+
