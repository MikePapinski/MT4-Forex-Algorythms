//+------------------------------------------------------------------+
//|                                                      testttt.mq4 |
//|                                                             Mike |
//|                                     https://www.divergencefx.com |
//+------------------------------------------------------------------+
#property copyright "Mike"
#property link      "https://www.divergencefx.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

// Description of the imported functions.
#import "MqlSqlDemo.dll"

// Function for opening a connection:
int CreateConnection(string sConnStr);
// Function for reading the last message:
string GetLastMessage();
// Function for executing the SQL command:
int ExecuteSql(string sSql);
// Function for reading an integer:
int ReadInt(string sSql);
// Function for reading a string:
string ReadString(string sSql);
// Function for closing a connection:
void CloseConnection();

// End of import:
#import


int OnInit()
{

Print("testos");
  Comment("dupa");    
    if (CreateConnection("test") != 0)
   {
      // Failed to establish the connection.
      // Print the message and exit:
      Print("Error when opening connection. ", GetLastMessage());
      return(INIT_FAILED);
   }
   Print("Connected to database.");
   
return 0 ;
}


//Unload All Data on Exit  
void OnDeinit(const int reason){}





//Action to do on every tick
int start()
  {
  
  return 0;
  }