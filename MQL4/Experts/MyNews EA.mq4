//+------------------------------------------------------------------+
//|                                                     MyNewsEA vol 1.1.mq4 |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Divergence FX"
#property link      "www.DivergenceFX.com"
#property version   "1.1"
#property strict     "This is MyNews EA develepod to take advantage of price movements during economic news releases."
#property icon "icon1.ico"

double ProductVersion = 1.2;
int ProductID = 1;
int IDUserID=0;
int NewsID=0;


#include <MQLMySQL.mqh>
#include <DftChartTemplate.mqh>
#include <MyNewsEA_Dashboard.mqh>
#include <MyNewsEA_TradeManagement.mqh>


#import "MyNewsEA.dll"
void getText(char&[],int);
#import
char buffer[10240];




//DB connectivity
 int DB; // database identifiers
 string Host = "";
 string User = "";
 string Password = "";
 string Database = "";
 int Port     = 3306;
 int Socket   = 0;
 int ClientFlag = 0; 
 double CurrPips=0;
 

//User Authentication input
bool AuthStatus = false;
string extern UserAuth = "";
string extern PassAuth = "";
string UserAuthCheck = "";
string PassAuthCheck = "";
datetime UserLicenseDate = 0;
int UserID=0;

//News Trading parameters
datetime NextNewsDate = 0;
string NewsCurr1 = "";
string NewsCurr2 = "";

double BreakOut_Distance_Pips;
double TP_Pips;
double SL_Pips;
double SL_Trail;
double BreakEvenPips;


string Currency_1_Value;
string Currency_2_Value;
string NewsType;
string NewsCurrency;
datetime NewsDateTime;
int TradingStatus;
string StatusForDashboard;


//Testing parameters
int TestingDateStep=1;




int OnInit()
  {

                  
   VerifyUserAccess(AuthStatus);

   Currency_1_Value=FindCurrency1();
   Currency_2_Value=FindCurrency2(FindCurrency1());
   TestingDateStep=1;
   TradingStatus=0;
   

   if (AuthStatus== true && IsTesting()==false)
   {

       PostActivity();
     GetSettings(BreakOut_Distance_Pips, TP_Pips, SL_Pips, BreakEvenPips);
     ChangeChartFormat();
     DrawDashboard();
     UpdateDashboard( UserAuthCheck,UserLicenseDate,0,"","",0,"");
      
      GetClosestNewsDateTime(Currency_1_Value,Currency_2_Value);
   }
   else{ } 
 return 0 ;
  }
  
void OnDeinit(const int reason){}

int start()
  {
  
   if (AuthStatus == false || IsTesting()==true){
      Comment("Not authorized");
   }
   
    else
    {
    
   
      TradeManagement(TradingStatus,NewsDateTime,BreakOut_Distance_Pips,TP_Pips,SL_Pips,SL_Trail,BreakEvenPips);
      UpdateDashboard( UserAuthCheck,UserLicenseDate,(NewsDateTime - TimeCurrent()),NewsCurrency,NewsType,NewsDateTime,ConvertStepComment(TradingStatus));
      
      if (TradingStatus==8){GetClosestNewsDateTime(Currency_1_Value,Currency_2_Value); TestingDateStep=TestingDateStep+1;TradingStatus=0;}
      if (TradingStatus==0 && NewsDateTime<TimeCurrent()){GetClosestNewsDateTime(Currency_1_Value,Currency_2_Value);}
      if (TradingStatus==7){
      
      TradingStatus=8;}
      if(IsNewBar()==true){PostActivity();}
    }
   return 0;
  }
//+------------------------------------------------------------------+


//This function is to validate if user is athenticated
void VerifyUserAccess(bool &status)
{
   //connect mysql
   //get user
         string text="";
         getText(buffer,1);
         User=CharArrayToString(buffer);
         getText(buffer,2);
         Password=CharArrayToString(buffer);
         getText(buffer,3);
         Host=CharArrayToString(buffer);
         getText(buffer,4);
         Database=CharArrayToString(buffer);

       
       
       
       bool VerificationStatus = false;
       
       
       //CHECK IF USER EXIST
        DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
       string Query;
       int Cursor;
       Query = "CALL `dft`.`Verify_EA_User`('" + UserAuth + "', '" + PassAuth + "');";
       Cursor = MySqlCursorOpen(DB, Query);
       if (Cursor >= 0) { if (MySqlCursorFetchRow(Cursor)){IDUserID=MySqlGetFieldAsInt(Cursor, 0 );UserAuthCheck=MySqlGetFieldAsString(Cursor, 2 );status = true; }else{ status = false;}}
      MySqlDisconnect(DB);
 
      

      //CHECK IF PRODUCT ADDED
      if(status == true)
     {
      int DB1 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB1 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB1);}
     string Query1;
      int Cursor1;
       Query1 = "CALL `dft`.`Verify_EA_User_Product`('" + UserAuth + "', " + ProductID + ");";
       Cursor1 = MySqlCursorOpen(DB1, Query1);
       if (Cursor1 >= 0) 
         {if (MySqlCursorFetchRow(Cursor1)){UserLicenseDate=MySqlGetFieldAsDatetime(Cursor1, 3 );status = true;}else{ MessageBox("You do not have access to this product. Please go to www.DivergenceFX.com and add this product to your user profile.");status = false;}}
               MySqlDisconnect(DB1);
      }
      
      
      
      //CHECK IF MT4 ACCOUNT IS CORRECT
      if(status == true)
     {
      int DB2 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB2 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB2);}
     string Query2;
      int Cursor2;
       Query2 = "CALL `dft`.`Verify_EA_Product_MT4_Account`('" + AccountNumber() + "', " + ProductID + ");";
       Cursor2 = MySqlCursorOpen(DB2, Query2);
       if (Cursor2 >= 0) 
         {if (MySqlCursorFetchRow(Cursor2)){status = true;}else{ MessageBox("This mt4 account is not mapped with your product. Please go to www.DivergenceFX.com and change mt4 account number in settings");status = false;}}
               MySqlDisconnect(DB2);
      }
      
      
        //CHECK IF VERSION IS CORRECT
      if(status == true)
     {
      int DB3 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB3 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB3);}
     string Query3;
      int Cursor3;
       Query3 = "CALL `dft`.`Verify_EA_Product_Version`('" + ProductVersion + "', " + ProductID + ");";
       Cursor3 = MySqlCursorOpen(DB3, Query3);
       if (Cursor3 >= 0) 
         {if (MySqlCursorFetchRow(Cursor3)){status = true;}else{ MessageBox("This product has been updated. Please go to www.DivergenceFX.com and download the new version.");status = false;}}
               MySqlDisconnect(DB3);
      }
      
      
      //VERIFIED!!
      if(status == true){MessageBox("Hello " + UserAuth + ", Happy Trading!");}
           
}



void GetClosestNewsDateTime(string CurrencyNumber1, string CurrencyNumber2)
{

 
         datetime CheckDate;
          //connect mysql
          DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
          if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
          string Query;
          int Cursor;
          Query = "CALL `dft`.`Get_Next_News_Event`('" + Currency_1_Value  +"', '" + Currency_2_Value + "', '"+TimeCurrent()+"');";
          Cursor = MySqlCursorOpen(DB, Query);
          if (Cursor >= 0)
             {
                  if (MySqlCursorFetchRow(Cursor))
                     {
                      
                       NewsID=MySqlGetFieldAsInt(Cursor, 0 );
                       NewsType = MySqlGetFieldAsString(Cursor, 3 ); // code
                       NewsCurrency = MySqlGetFieldAsString(Cursor, 2 ); // code
                       
                       
                     //  NewsDateTime = MySqlGetFieldAsDatetime(Cursor, 1 ); // code
                     //  MessageBox(MySqlGetFieldAsDatetime(Cursor, 5 ));
                       
                       NewsDateTime = ((TimeCurrent()-MySqlGetFieldAsDatetime(Cursor, 5 ))+MySqlGetFieldAsDatetime(Cursor, 1 ));
                       
                       CheckDate = NewsDateTime ;

                     }
                     else
                     {
                        NewsID=0;
                       NewsType = "Contact Admin"; // code
                       NewsCurrency = "Contact Admin"; // code
                       NewsDateTime = "2099.01.01 00:00:00"; // code
                        CheckDate = NewsDateTime ;
                        
                     }
         
             }
          else
             {
              Print ("Cursor opening failed. Error: ", MySqlErrorDescription);
              
         
             }
         
                        MySqlCursorClose(Cursor);
                        MySqlDisconnect(DB);

   
}

string ConvertStepComment(int StatusInfo)
{

string ReturnValue="";
   switch(StatusInfo)
   {
      case 0: ReturnValue= "Waiting for news"; break;
      case 1: ReturnValue= "Setting pending orders before news"; break;
      case 2: ReturnValue= "Adjusting pending orders";  break;
      case 3: ReturnValue= "News time - Order triggered";  break;
      case 4: ReturnValue= "Managing the trade";  break;
      case 5: ReturnValue= "Managing trades";  break;
      case 6: ReturnValue= "Finish";  break;

   }
return ReturnValue;
}





string FindCurrency1()
  {
string returnvalue;
   if(StringFind(Symbol(),"EUR")> -1){returnvalue= "EUR";}
   if(StringFind(Symbol(),"USD")> -1){returnvalue= "USD";}
   if(StringFind(Symbol(),"CAD")> -1){returnvalue= "CAD";}
   if(StringFind(Symbol(),"JPY")> -1){returnvalue= "JPY";}
   if(StringFind(Symbol(),"AUD")> -1){returnvalue= "AUD";}
   if(StringFind(Symbol(),"NZD")> -1){returnvalue= "NZD";}
   if(StringFind(Symbol(),"GBP")> -1){returnvalue= "GBP";}
   if(StringFind(Symbol(),"CHF")> -1){returnvalue= "CHF";}
return returnvalue;
  }
  
  string FindCurrency2(string CurrencyNumber1)
  {
string returnvalue;
   if(StringFind(Symbol(),"EUR")> -1 && CurrencyNumber1 != "EUR"){returnvalue= "EUR";}
   if(StringFind(Symbol(),"USD")> -1 && CurrencyNumber1 != "USD"){returnvalue= "USD";}
   if(StringFind(Symbol(),"CAD")> -1 && CurrencyNumber1 != "CAD"){returnvalue= "CAD";}
   if(StringFind(Symbol(),"JPY")> -1 && CurrencyNumber1 != "JPY"){returnvalue= "JPY";}
   if(StringFind(Symbol(),"AUD")> -1 && CurrencyNumber1 != "AUD"){returnvalue= "AUD";}
   if(StringFind(Symbol(),"NZD")> -1 && CurrencyNumber1 != "NZD"){returnvalue= "NZD";}
   if(StringFind(Symbol(),"GBP")> -1 && CurrencyNumber1 != "GBP"){returnvalue= "GBP";}
   if(StringFind(Symbol(),"CHF")> -1 && CurrencyNumber1 != "CHF"){returnvalue= "CHF";}
return returnvalue;
  }
  
  
  
  //Get values
void GetSettings(double &BreakOutValue, double &TPValue, double &SLValue, double &BreakEvenValue)

{
   //connect mysql
         string text="";
         getText(buffer,1);
         User=CharArrayToString(buffer);
         getText(buffer,2);
         Password=CharArrayToString(buffer);
         getText(buffer,3);
         Host=CharArrayToString(buffer);
         getText(buffer,4);
         Database=CharArrayToString(buffer);

        DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
       string Query;
       int Cursor;
       Query = "CALL `dft`.`Get_EA_Settings`(" + ProductID + ");";
       Cursor = MySqlCursorOpen(DB, Query);
       if (Cursor >= 0) { 
       
       if (MySqlCursorFetchRow(Cursor)){BreakOutValue= MySqlGetFieldAsDouble(Cursor, 1 );};
       if (MySqlCursorFetchRow(Cursor)){TPValue= MySqlGetFieldAsDouble(Cursor, 1 ); };
       if (MySqlCursorFetchRow(Cursor)){SLValue= MySqlGetFieldAsDouble(Cursor, 1 );};
       if (MySqlCursorFetchRow(Cursor)){BreakEvenValue= MySqlGetFieldAsDouble(Cursor, 1 ); };
       
       }
      MySqlDisconnect(DB);
 
   }
   
   
   
   
   static int BARS;
//+------------------------------------------------------------------+
//| NewBar function                                                  |
//+------------------------------------------------------------------+
bool IsNewBar()
   {
      if(BARS!=Bars(_Symbol,PERIOD_M5))
        {
            BARS=Bars(_Symbol,PERIOD_M5);
            return(true);
        }
        else
        {
         return(false);
        }
     
   }
   
   
//This function is to post done trade in to database
void PostActivity()
{

  string text="";
         getText(buffer,1);
         User=CharArrayToString(buffer);
         getText(buffer,2);
         Password=CharArrayToString(buffer);
         getText(buffer,3);
         Host=CharArrayToString(buffer);
         getText(buffer,4);
         Database=CharArrayToString(buffer);
       DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
       string Query;
       Query = "CALL `dft`.`Add_Product_Activity`("+IDUserID+", "+ProductID +");";
       bool test = MySqlExecute(DB, Query);
            MySqlDisconnect(DB);
}


 
  
  //Get values
void PostTradeDB(double Profitos)

{
   string text="";
         getText(buffer,1);
         User=CharArrayToString(buffer);
         getText(buffer,2);
         Password=CharArrayToString(buffer);
         getText(buffer,3);
         Host=CharArrayToString(buffer);
         getText(buffer,4);
         Database=CharArrayToString(buffer);
       DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
       string Query;
       Query = "CALL `dft`.`Add_EA_Trade`(" + IDUserID + "," + ProductID + "," + NewsID + ", " + Profitos + ",123);";
       bool test = MySqlExecute(DB, Query);
            MySqlDisconnect(DB);
 
   }