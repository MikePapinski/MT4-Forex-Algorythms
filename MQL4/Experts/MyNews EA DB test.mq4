//+------------------------------------------------------------------+
//|                                                     MyNewsEA.mq4 |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""
#property version   "1.00"
#property strict

#include <MQLMySQL.mqh>
#include <DftChartTemplate.mqh>
#include <MyNewsEA_Dashboard.mqh>
#include <MyNewsEA_TradeManagement.mqh>

#import "hello-world.dll"
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
enum __in{ 
   _p1, // USD
   _p2, // EUR
   _p3, // JPY
   _p4,  // CAD 
   _p5, // GBP
   _p6, // AUD
   _p7, // NZD
};
extern __in Currency_1 = _p1;
extern __in Currency_2 = _p1;
extern int BreakOut_Distance_Pips = 150;
extern int TP_Pips = 150;
extern int SL_Pips = 150;
extern int SL_Trail = 100;


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
   ConvertEnumCurrToString(Currency_1,Currency_1_Value);
   ConvertEnumCurrToString(Currency_2,Currency_2_Value);
   TestingDateStep=1;
   TradingStatus=0;
   if (AuthStatus== true)
   {
     ChangeChartFormat();
     DrawDashboard();
     UpdateDashboard( UserAuthCheck,UserLicenseDate,0,"","",0,"");
      
      GetClosestNewsDateTime(Currency_1_Value,Currency_2_Value);
   }
   else{ Comment("EA not connected to DB"); } 
 return 0 ;
  }
  
void OnDeinit(const int reason){}

int start()
  {
  
   if (AuthStatus == false){
   
   Comment("test");
   
   }
   
    else
    {
      TradeManagement(TradingStatus,NewsDateTime,BreakOut_Distance_Pips,TP_Pips,SL_Pips,SL_Trail);
      UpdateDashboard( UserAuthCheck,UserLicenseDate,(NewsDateTime - TimeCurrent()),NewsCurrency,NewsType,NewsDateTime,ConvertStepComment(TradingStatus));
      if (TradingStatus==7){GetClosestNewsDateTime(Currency_1_Value,Currency_2_Value); TestingDateStep=TestingDateStep+1;TradingStatus=0;}
      if (TradingStatus==0 && NewsDateTime<TimeCurrent()){GetClosestNewsDateTime(Currency_1_Value,Currency_2_Value);}
      if (TradingStatus==6){
      PostFinishedTrade();
      TradingStatus=7;}
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
         
         
       DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
       string Query;
       int Cursor;
       Query = "CALL `dft`.`Auth_EA_User`('" + UserAuth + "', '" + PassAuth + "', 2, '" + AccountNumber() + "');";
       Cursor = MySqlCursorOpen(DB, Query);
       if (Cursor >= 0)
          {
               if (MySqlCursorFetchRow(Cursor))
                  {
                   
                   UserAuthCheck = MySqlGetFieldAsString(Cursor, 1); // code
                   UserLicenseDate = MySqlGetFieldAsDatetime(Cursor, 4 );
                   
                    MySqlCursorClose(Cursor); // NEVER FORGET TO CLOSE CURSOR !!!
                     MySqlDisconnect(DB);
                   status = true;
                  
                  }
                  
                 
          
          }
       else
          {
           Print ("Cursor opening failed. Error: ", MySqlErrorDescription);
           status = false;
            MySqlDisconnect(DB);
          }
 
}



void GetClosestNewsDateTime(string CurrencyNumber1, string CurrencyNumber2)
{

 if(1==2)
 {
   switch(TestingDateStep)
   {
case 1: NewsDateTime="2017/01/02 10:55:00";break;
case 2: NewsDateTime="2017/01/03 10:55:00";break;
case 3: NewsDateTime="2017/01/03 17:00:00";break;
case 4: NewsDateTime="2017/01/04 12:00:00";break;
case 5: NewsDateTime="2017/01/04 21:00:00";break;
case 6: NewsDateTime="2017/01/05 15:15:00";break;
case 7: NewsDateTime="2017/01/05 17:00:00";break;
case 8: NewsDateTime="2017/01/05 18:00:00";break;
case 9: NewsDateTime="2017/01/06 15:30:00";break;
case 10: NewsDateTime="2017/01/07 19:15:00";break;
case 11: NewsDateTime="2017/01/10 17:00:00";break;
case 12: NewsDateTime="2017/01/11 17:30:00";break;
case 13: NewsDateTime="2017/01/11 18:00:00";break;
case 14: NewsDateTime="2017/01/12 14:30:00";break;
case 15: NewsDateTime="2017/01/13 02:00:00";break;
case 16: NewsDateTime="2017/01/13 15:30:00";break;
case 17: NewsDateTime="2017/01/17 12:00:00";break;
case 18: NewsDateTime="2017/01/18 12:00:00";break;
case 19: NewsDateTime="2017/01/18 15:30:00";break;
case 20: NewsDateTime="2017/01/18 22:00:00";break;
case 21: NewsDateTime="2017/01/19 14:45:00";break;
case 22: NewsDateTime="2017/01/19 15:30:00";break;
case 23: NewsDateTime="2017/01/19 18:00:00";break;
case 24: NewsDateTime="2017/01/19 18:15:00";break;
case 25: NewsDateTime="2017/01/20 03:00:00";break;
case 26: NewsDateTime="2017/01/20 19:00:00";break;
case 27: NewsDateTime="2017/01/23 13:30:00";break;
case 28: NewsDateTime="2017/01/23 20:30:00";break;
case 29: NewsDateTime="2017/01/24 10:30:00";break;
case 30: NewsDateTime="2017/01/24 17:00:00";break;
case 31: NewsDateTime="2017/01/25 11:00:00";break;
case 32: NewsDateTime="2017/01/25 17:30:00";break;
case 33: NewsDateTime="2017/01/26 17:00:00";break;
case 34: NewsDateTime="2017/01/27 15:30:00";break;
case 35: NewsDateTime="2017/01/30 17:00:00";break;
case 36: NewsDateTime="2017/01/31 10:00:00";break;
case 37: NewsDateTime="2017/01/31 10:55:00";break;
case 38: NewsDateTime="2017/01/31 12:00:00";break;
case 39: NewsDateTime="2017/01/31 17:00:00";break;
case 40: NewsDateTime="2017/02/01 10:55:00";break;
case 41: NewsDateTime="2017/02/01 15:15:00";break;
case 42: NewsDateTime="2017/02/01 17:00:00";break;
case 43: NewsDateTime="2017/02/01 17:30:00";break;
case 44: NewsDateTime="2017/02/01 21:00:00";break;
case 45: NewsDateTime="2017/02/02 14:15:00";break;
case 46: NewsDateTime="2017/02/03 15:30:00";break;
case 47: NewsDateTime="2017/02/03 17:00:00";break;
case 48: NewsDateTime="2017/02/06 16:00:00";break;
case 49: NewsDateTime="2017/02/07 17:00:00";break;
case 50: NewsDateTime="2017/02/08 17:30:00";break;
case 51: NewsDateTime="2017/02/14 09:00:00";break;
case 52: NewsDateTime="2017/02/14 12:00:00";break;
case 53: NewsDateTime="2017/02/14 15:30:00";break;
case 54: NewsDateTime="2017/02/14 17:00:00";break;
case 55: NewsDateTime="2017/02/15 15:30:00";break;
case 56: NewsDateTime="2017/02/15 17:00:00";break;
case 57: NewsDateTime="2017/02/15 17:30:00";break;
case 58: NewsDateTime="2017/02/16 14:30:00";break;
case 59: NewsDateTime="2017/02/16 15:30:00";break;
case 60: NewsDateTime="2017/02/16 21:00:00";break;
case 61: NewsDateTime="2017/02/21 10:30:00";break;
case 62: NewsDateTime="2017/02/22 11:00:00";break;
case 63: NewsDateTime="2017/02/22 12:00:00";break;
case 64: NewsDateTime="2017/02/22 17:00:00";break;
case 65: NewsDateTime="2017/02/22 20:00:00";break;
case 66: NewsDateTime="2017/02/22 21:00:00";break;
case 67: NewsDateTime="2017/02/23 09:00:00";break;
case 68: NewsDateTime="2017/02/23 18:00:00";break;
case 69: NewsDateTime="2017/02/24 17:00:00";break;
case 70: NewsDateTime="2017/02/27 15:30:00";break;
case 71: NewsDateTime="2017/02/27 17:00:00";break;
case 72: NewsDateTime="2017/02/28 13:00:00";break;
case 73: NewsDateTime="2017/02/28 15:30:00";break;
case 74: NewsDateTime="2017/02/28 17:00:00";break;
case 75: NewsDateTime="2017/03/01 04:00:00";break;
case 76: NewsDateTime="2017/03/01 10:55:00";break;
case 77: NewsDateTime="2017/03/01 17:00:00";break;
case 78: NewsDateTime="2017/03/01 17:30:00";break;
case 79: NewsDateTime="2017/03/02 12:00:00";break;
case 80: NewsDateTime="2017/03/03 17:00:00";break;
case 81: NewsDateTime="2017/03/03 19:15:00";break;
case 82: NewsDateTime="2017/03/03 20:00:00";break;
case 83: NewsDateTime="2017/03/08 15:15:00";break;
case 84: NewsDateTime="2017/03/08 17:30:00";break;
case 85: NewsDateTime="2017/03/09 12:00:00";break;
case 86: NewsDateTime="2017/03/09 14:45:00";break;
case 87: NewsDateTime="2017/03/09 15:30:00";break;
case 88: NewsDateTime="2017/03/10 12:00:00";break;
case 89: NewsDateTime="2017/03/10 15:30:00";break;
case 90: NewsDateTime="2017/03/13 15:30:00";break;
case 91: NewsDateTime="2017/03/14 12:00:00";break;
case 92: NewsDateTime="2017/03/14 14:30:00";break;
case 93: NewsDateTime="2017/03/15 14:30:00";break;
case 94: NewsDateTime="2017/03/15 16:30:00";break;
case 95: NewsDateTime="2017/03/15 20:00:00";break;
case 96: NewsDateTime="2017/03/15 20:20:00";break;
case 97: NewsDateTime="2017/03/15 20:30:00";break;
case 98: NewsDateTime="2017/03/16 12:00:00";break;
case 99: NewsDateTime="2017/03/16 14:30:00";break;
case 100: NewsDateTime="2017/03/16 16:00:00";break;
case 101: NewsDateTime="2017/03/21 01:30:00";break;
case 102: NewsDateTime="2017/03/22 16:00:00";break;
case 103: NewsDateTime="2017/03/22 16:30:00";break;
case 104: NewsDateTime="2017/03/23 14:45:00";break;
case 105: NewsDateTime="2017/03/23 16:00:00";break;
case 106: NewsDateTime="2017/03/24 10:30:00";break;
case 107: NewsDateTime="2017/03/24 14:30:00";break;
case 108: NewsDateTime="2017/03/27 10:00:00";break;
case 109: NewsDateTime="2017/03/28 16:00:00";break;
case 110: NewsDateTime="2017/03/28 18:50:00";break;
case 111: NewsDateTime="2017/03/28 22:30:00";break;
case 112: NewsDateTime="2017/03/29 16:00:00";break;
case 113: NewsDateTime="2017/03/29 16:30:00";break;
case 114: NewsDateTime="2017/03/30 14:30:00";break;
case 115: NewsDateTime="2017/03/31 10:00:00";break;
case 116: NewsDateTime="2017/03/31 11:00:00";break;
case 117: NewsDateTime="2017/04/03 09:55:00";break;
case 118: NewsDateTime="2017/04/03 16:00:00";break;
case 119: NewsDateTime="2017/04/04 15:30:00";break;
case 120: NewsDateTime="2017/04/05 14:15:00";break;
case 121: NewsDateTime="2017/04/05 16:00:00";break;
case 122: NewsDateTime="2017/04/05 16:30:00";break;
case 123: NewsDateTime="2017/04/05 20:00:00";break;
case 124: NewsDateTime="2017/04/06 09:00:00";break;
case 125: NewsDateTime="2017/04/06 13:30:00";break;
case 126: NewsDateTime="2017/04/07 14:30:00";break;
case 127: NewsDateTime="2017/04/10 22:10:00";break;
case 128: NewsDateTime="2017/04/11 11:00:00";break;
case 129: NewsDateTime="2017/04/11 16:00:00";break;
case 130: NewsDateTime="2017/04/12 16:30:00";break;
case 131: NewsDateTime="2017/04/13 14:30:00";break;
case 132: NewsDateTime="2017/04/14 14:30:00";break;
case 133: NewsDateTime="2017/04/18 14:30:00";break;
case 134: NewsDateTime="2017/04/19 11:00:00";break;
case 135: NewsDateTime="2017/04/19 16:30:00";break;
case 136: NewsDateTime="2017/04/20 14:30:00";break;
case 137: NewsDateTime="2017/04/21 09:30:00";break;
case 138: NewsDateTime="2017/04/21 16:00:00";break;
case 139: NewsDateTime="2017/04/24 10:00:00";break;
case 140: NewsDateTime="2017/04/25 16:00:00";break;
case 141: NewsDateTime="2017/04/26 16:30:00";break;
case 142: NewsDateTime="2017/04/27 13:45:00";break;
case 143: NewsDateTime="2017/04/27 14:30:00";break;
case 144: NewsDateTime="2017/04/27 16:00:00";break;
case 145: NewsDateTime="2017/04/28 11:00:00";break;
case 146: NewsDateTime="2017/04/28 14:30:00";break;
case 147: NewsDateTime="2017/05/01 16:00:00";break;
case 148: NewsDateTime="2017/05/02 09:55:00";break;
case 149: NewsDateTime="2017/05/03 09:55:00";break;
case 150: NewsDateTime="2017/05/03 14:15:00";break;
case 151: NewsDateTime="2017/05/03 16:00:00";break;
case 152: NewsDateTime="2017/05/03 16:30:00";break;
case 153: NewsDateTime="2017/05/03 20:00:00";break;
case 154: NewsDateTime="2017/05/04 18:30:00";break;
case 155: NewsDateTime="2017/05/05 14:30:00";break;
case 156: NewsDateTime="2017/05/05 19:30:00";break;
case 157: NewsDateTime="2017/05/09 16:00:00";break;
case 158: NewsDateTime="2017/05/10 13:00:00";break;
case 159: NewsDateTime="2017/05/10 16:30:00";break;
case 160: NewsDateTime="2017/05/11 14:30:00";break;
case 161: NewsDateTime="2017/05/12 08:00:00";break;
case 162: NewsDateTime="2017/05/12 14:30:00";break;
case 163: NewsDateTime="2017/05/16 11:00:00";break;
case 164: NewsDateTime="2017/05/16 14:30:00";break;
case 165: NewsDateTime="2017/05/17 11:00:00";break;
case 166: NewsDateTime="2017/05/17 16:30:00";break;
case 167: NewsDateTime="2017/05/18 13:30:00";break;
case 168: NewsDateTime="2017/05/18 14:30:00";break;
case 169: NewsDateTime="2017/05/18 19:00:00";break;
case 170: NewsDateTime="2017/05/23 08:00:00";break;
case 171: NewsDateTime="2017/05/23 09:30:00";break;
case 172: NewsDateTime="2017/05/23 10:00:00";break;
case 173: NewsDateTime="2017/05/23 16:00:00";break;
case 174: NewsDateTime="2017/05/24 14:45:00";break;
case 175: NewsDateTime="2017/05/24 16:00:00";break;
case 176: NewsDateTime="2017/05/24 16:30:00";break;
case 177: NewsDateTime="2017/05/24 20:00:00";break;
case 178: NewsDateTime="2017/05/26 14:30:00";break;
case 179: NewsDateTime="2017/05/29 15:00:00";break;
case 180: NewsDateTime="2017/05/30 16:00:00";break;
case 181: NewsDateTime="2017/05/31 10:00:00";break;
case 182: NewsDateTime="2017/05/31 11:00:00";break;
case 183: NewsDateTime="2017/05/31 16:00:00";break;
case 184: NewsDateTime="2017/06/01 09:55:00";break;
case 185: NewsDateTime="2017/06/01 14:00:00";break;
case 186: NewsDateTime="2017/06/01 14:15:00";break;
case 187: NewsDateTime="2017/06/01 16:00:00";break;
case 188: NewsDateTime="2017/06/01 17:00:00";break;
case 189: NewsDateTime="2017/06/02 14:30:00";break;
case 190: NewsDateTime="2017/06/05 16:00:00";break;
case 191: NewsDateTime="2017/06/06 16:00:00";break;
case 192: NewsDateTime="2017/06/07 16:30:00";break;
case 193: NewsDateTime="2017/06/08 13:45:00";break;
case 194: NewsDateTime="2017/06/08 14:30:00";break;
case 195: NewsDateTime="2017/06/13 11:00:00";break;
case 196: NewsDateTime="2017/06/13 14:30:00";break;
case 197: NewsDateTime="2017/06/14 14:30:00";break;
case 198: NewsDateTime="2017/06/14 16:30:00";break;
case 199: NewsDateTime="2017/06/14 20:00:00";break;
case 200: NewsDateTime="2017/06/14 20:30:00";break;
case 201: NewsDateTime="2017/06/15 14:30:00";break;
case 202: NewsDateTime="2017/06/16 11:00:00";break;
case 203: NewsDateTime="2017/06/16 14:30:00";break;
case 204: NewsDateTime="2017/06/21 16:00:00";break;
case 205: NewsDateTime="2017/06/21 16:30:00";break;
case 206: NewsDateTime="2017/06/22 16:00:00";break;
case 207: NewsDateTime="2017/06/23 09:30:00";break;
case 208: NewsDateTime="2017/06/23 16:00:00";break;
case 209: NewsDateTime="2017/06/23 20:15:00";break;
case 210: NewsDateTime="2017/06/26 10:00:00";break;
case 211: NewsDateTime="2017/06/26 14:30:00";break;
case 212: NewsDateTime="2017/06/26 19:30:00";break;
case 213: NewsDateTime="2017/06/27 10:00:00";break;
case 214: NewsDateTime="2017/06/27 16:00:00";break;
case 215: NewsDateTime="2017/06/27 19:00:00";break;
case 216: NewsDateTime="2017/06/28 15:30:00";break;
case 217: NewsDateTime="2017/06/28 16:00:00";break;
case 218: NewsDateTime="2017/06/28 16:30:00";break;
case 219: NewsDateTime="2017/06/29 14:30:00";break;
case 220: NewsDateTime="2017/06/30 09:55:00";break;
case 221: NewsDateTime="2017/06/30 11:00:00";break;
case 222: NewsDateTime="2017/07/03 09:55:00";break;
case 223: NewsDateTime="2017/07/03 16:00:00";break;
case 224: NewsDateTime="2017/07/05 20:00:00";break;
case 225: NewsDateTime="2017/07/06 13:30:00";break;
case 226: NewsDateTime="2017/07/06 14:15:00";break;
case 227: NewsDateTime="2017/07/06 16:00:00";break;
case 228: NewsDateTime="2017/07/06 17:00:00";break;
case 229: NewsDateTime="2017/07/07 14:30:00";break;
case 230: NewsDateTime="2017/07/11 16:00:00";break;
case 231: NewsDateTime="2017/07/12 16:00:00";break;
case 232: NewsDateTime="2017/07/12 16:30:00";break;
case 233: NewsDateTime="2017/07/13 14:30:00";break;
case 234: NewsDateTime="2017/07/13 15:30:00";break;
case 235: NewsDateTime="2017/07/14 14:30:00";break;
case 236: NewsDateTime="2017/07/17 11:00:00";break;
case 237: NewsDateTime="2017/07/18 11:00:00";break;
case 238: NewsDateTime="2017/07/19 14:30:00";break;
case 239: NewsDateTime="2017/07/19 16:30:00";break;
case 240: NewsDateTime="2017/07/20 13:45:00";break;
case 241: NewsDateTime="2017/07/20 14:30:00";break;
case 242: NewsDateTime="2017/07/24 09:30:00";break;
case 243: NewsDateTime="2017/07/24 16:00:00";break;
case 244: NewsDateTime="2017/07/25 10:00:00";break;
case 245: NewsDateTime="2017/07/25 16:00:00";break;
case 246: NewsDateTime="2017/07/26 16:00:00";break;
case 247: NewsDateTime="2017/07/26 16:30:00";break;
case 248: NewsDateTime="2017/07/26 20:00:00";break;
case 249: NewsDateTime="2017/07/27 14:30:00";break;
case 250: NewsDateTime="2017/07/28 14:30:00";break;
case 251: NewsDateTime="2017/07/31 11:00:00";break;
case 252: NewsDateTime="2017/07/31 16:00:00";break;
case 253: NewsDateTime="2017/08/01 09:55:00";break;
case 254: NewsDateTime="2017/08/01 16:00:00";break;
case 255: NewsDateTime="2017/08/02 14:15:00";break;
case 256: NewsDateTime="2017/08/02 16:30:00";break;
case 257: NewsDateTime="2017/08/03 16:00:00";break;
case 258: NewsDateTime="2017/08/04 14:30:00";break;
case 259: NewsDateTime="2017/08/08 16:00:00";break;
case 260: NewsDateTime="2017/08/09 16:30:00";break;
case 261: NewsDateTime="2017/08/10 14:30:00";break;
case 262: NewsDateTime="2017/08/11 14:30:00";break;
case 263: NewsDateTime="2017/08/15 08:00:00";break;
case 264: NewsDateTime="2017/08/15 14:30:00";break;
case 265: NewsDateTime="2017/08/16 14:30:00";break;
case 266: NewsDateTime="2017/08/16 16:30:00";break;
case 267: NewsDateTime="2017/08/16 20:00:00";break;
case 268: NewsDateTime="2017/08/17 11:00:00";break;
case 269: NewsDateTime="2017/08/17 13:30:00";break;
case 270: NewsDateTime="2017/08/17 14:30:00";break;
case 271: NewsDateTime="2017/08/22 11:00:00";break;
case 272: NewsDateTime="2017/08/23 09:25:00";break;
case 273: NewsDateTime="2017/08/23 09:30:00";break;
case 274: NewsDateTime="2017/08/23 16:00:00";break;
case 275: NewsDateTime="2017/08/23 16:30:00";break;
case 276: NewsDateTime="2017/08/24 16:00:00";break;
case 277: NewsDateTime="2017/08/25 08:00:00";break;
case 278: NewsDateTime="2017/08/25 10:00:00";break;
case 279: NewsDateTime="2017/08/25 14:30:00";break;
case 280: NewsDateTime="2017/08/25 16:00:00";break;
case 281: NewsDateTime="2017/08/25 21:00:00";break;
case 282: NewsDateTime="2017/08/29 16:00:00";break;
case 283: NewsDateTime="2017/08/30 14:15:00";break;
case 284: NewsDateTime="2017/08/30 14:30:00";break;
case 285: NewsDateTime="2017/08/30 15:15:00";break;
case 286: NewsDateTime="2017/08/30 16:30:00";break;
case 287: NewsDateTime="2017/08/31 09:55:00";break;
case 288: NewsDateTime="2017/08/31 11:00:00";break;
case 289: NewsDateTime="2017/08/31 16:00:00";break;
case 290: NewsDateTime="2017/09/01 09:55:00";break;
case 291: NewsDateTime="2017/09/01 14:30:00";break;
case 292: NewsDateTime="2017/09/01 16:00:00";break;
case 293: NewsDateTime="2017/09/06 16:00:00";break;
case 294: NewsDateTime="2017/09/07 13:45:00";break;
case 295: NewsDateTime="2017/09/07 14:30:00";break;
case 296: NewsDateTime="2017/09/07 17:00:00";break;
case 297: NewsDateTime="2017/09/12 16:00:00";break;
case 298: NewsDateTime="2017/09/13 14:30:00";break;
case 299: NewsDateTime="2017/09/13 16:30:00";break;
case 300: NewsDateTime="2017/09/14 14:30:00";break;
case 301: NewsDateTime="2017/09/15 14:30:00";break;
case 302: NewsDateTime="2017/09/18 11:00:00";break;
case 303: NewsDateTime="2017/09/19 11:00:00";break;
case 304: NewsDateTime="2017/09/19 14:30:00";break;
case 305: NewsDateTime="2017/09/19 16:00:00";break;
case 306: NewsDateTime="2017/09/20 16:00:00";break;
case 307: NewsDateTime="2017/09/20 16:30:00";break;
case 308: NewsDateTime="2017/09/20 20:00:00";break;
case 309: NewsDateTime="2017/09/20 20:30:00";break;
case 310: NewsDateTime="2017/09/21 14:30:00";break;
case 311: NewsDateTime="2017/09/21 15:30:00";break;
case 312: NewsDateTime="2017/09/22 09:30:00";break;
case 313: NewsDateTime="2017/09/22 10:00:00";break;
case 314: NewsDateTime="2017/09/22 11:30:00";break;
case 315: NewsDateTime="2017/09/24 18:00:00";break;
case 316: NewsDateTime="2017/09/25 10:00:00";break;
case 317: NewsDateTime="2017/09/25 15:00:00";break;
case 318: NewsDateTime="2017/09/26 16:00:00";break;
case 319: NewsDateTime="2017/09/26 18:45:00";break;
case 320: NewsDateTime="2017/09/27 14:30:00";break;
case 321: NewsDateTime="2017/09/27 16:00:00";break;
case 322: NewsDateTime="2017/09/27 16:30:00";break;
case 323: NewsDateTime="2017/09/27 21:20:00";break;
case 324: NewsDateTime="2017/09/28 14:30:00";break;
case 325: NewsDateTime="2017/09/29 09:55:00";break;
case 326: NewsDateTime="2017/09/29 11:00:00";break;
case 327: NewsDateTime="2017/09/29 16:15:00";break;
case 328: NewsDateTime="2017/10/02 09:55:00";break;
case 329: NewsDateTime="2017/10/02 16:00:00";break;
case 330: NewsDateTime="2017/10/03 14:30:00";break;
case 331: NewsDateTime="2017/10/04 14:15:00";break;
case 332: NewsDateTime="2017/10/04 16:00:00";break;
case 333: NewsDateTime="2017/10/04 16:30:00";break;
case 334: NewsDateTime="2017/10/04 19:15:00";break;
case 335: NewsDateTime="2017/10/04 21:15:00";break;
case 336: NewsDateTime="2017/10/05 13:30:00";break;
case 337: NewsDateTime="2017/10/05 15:10:00";break;
case 338: NewsDateTime="2017/10/06 14:30:00";break;
case 339: NewsDateTime="2017/10/11 16:00:00";break;
case 340: NewsDateTime="2017/10/11 20:00:00";break;
case 341: NewsDateTime="2017/10/12 14:30:00";break;
case 342: NewsDateTime="2017/10/12 16:30:00";break;
case 343: NewsDateTime="2017/10/12 17:00:00";break;
case 344: NewsDateTime="2017/10/13 14:30:00";break;
case 345: NewsDateTime="2017/10/13 19:00:00";break;
case 346: NewsDateTime="2017/10/15 15:00:00";break;
case 347: NewsDateTime="2017/10/17 11:00:00";break;
case 348: NewsDateTime="2017/10/18 10:10:00";break;
case 349: NewsDateTime="2017/10/18 14:30:00";break;
case 350: NewsDateTime="2017/10/18 16:30:00";break;
case 351: NewsDateTime="2017/10/19 14:30:00";break;
case 352: NewsDateTime="2017/10/20 16:00:00";break;
case 353: NewsDateTime="2017/10/21 01:30:00";break;
case 354: NewsDateTime="2017/10/24 09:30:00";break;
case 355: NewsDateTime="2017/10/25 10:00:00";break;
case 356: NewsDateTime="2017/10/25 14:30:00";break;
case 357: NewsDateTime="2017/10/25 16:00:00";break;
case 358: NewsDateTime="2017/10/25 16:30:00";break;
case 359: NewsDateTime="2017/10/26 13:45:00";break;
case 360: NewsDateTime="2017/10/26 14:30:00";break;
case 361: NewsDateTime="2017/10/26 16:00:00";break;
case 362: NewsDateTime="2017/10/27 14:30:00";break;
case 363: NewsDateTime="2017/10/31 12:00:00";break;
case 364: NewsDateTime="2017/10/31 16:00:00";break;
case 365: NewsDateTime="2017/11/01 14:15:00";break;
case 366: NewsDateTime="2017/11/01 16:00:00";break;
case 367: NewsDateTime="2017/11/01 16:30:00";break;
case 368: NewsDateTime="2017/11/01 20:00:00";break;
case 369: NewsDateTime="2017/11/02 10:55:00";break;
case 370: NewsDateTime="2017/11/02 14:30:00";break;
case 371: NewsDateTime="2017/11/03 14:30:00";break;
case 372: NewsDateTime="2017/11/03 16:00:00";break;
case 373: NewsDateTime="2017/11/07 11:00:00";break;
case 374: NewsDateTime="2017/11/07 17:00:00";break;
case 375: NewsDateTime="2017/11/07 21:30:00";break;
case 376: NewsDateTime="2017/11/08 17:30:00";break;
case 377: NewsDateTime="2017/11/14 09:00:00";break;
case 378: NewsDateTime="2017/11/14 12:00:00";break;
case 379: NewsDateTime="2017/11/14 15:30:00";break;
case 380: NewsDateTime="2017/11/15 15:30:00";break;
case 381: NewsDateTime="2017/11/15 17:30:00";break;
case 382: NewsDateTime="2017/11/16 12:00:00";break;
case 383: NewsDateTime="2017/11/16 15:30:00";break;
case 384: NewsDateTime="2017/11/17 10:30:00";break;
case 385: NewsDateTime="2017/11/17 15:30:00";break;
case 386: NewsDateTime="2017/11/20 16:00:00";break;
case 387: NewsDateTime="2017/11/20 18:00:00";break;
case 388: NewsDateTime="2017/11/21 17:00:00";break;
case 389: NewsDateTime="2017/11/22 01:00:00";break;
case 390: NewsDateTime="2017/11/22 15:30:00";break;
case 391: NewsDateTime="2017/11/22 17:30:00";break;
case 392: NewsDateTime="2017/11/22 21:00:00";break;
case 393: NewsDateTime="2017/11/23 09:00:00";break;
case 394: NewsDateTime="2017/11/23 10:30:00";break;
case 395: NewsDateTime="2017/11/23 14:30:00";break;
case 396: NewsDateTime="2017/11/24 11:00:00";break;
case 397: NewsDateTime="2017/11/27 17:00:00";break;
case 398: NewsDateTime="2017/11/28 16:45:00";break;
case 399: NewsDateTime="2017/11/28 17:00:00";break;
case 400: NewsDateTime="2017/11/29 15:30:00";break;
case 401: NewsDateTime="2017/11/29 17:00:00";break;
case 402: NewsDateTime="2017/11/29 17:30:00";break;
case 403: NewsDateTime="2017/11/30 10:55:00";break;
case 404: NewsDateTime="2017/11/30 12:00:00";break;
case 405: NewsDateTime="2017/12/01 10:55:00";break;
case 406: NewsDateTime="2017/12/01 17:00:00";break;
case 407: NewsDateTime="2017/12/05 17:00:00";break;
case 408: NewsDateTime="2017/12/06 15:15:00";break;
case 409: NewsDateTime="2017/12/06 17:30:00";break;
case 410: NewsDateTime="2017/12/07 18:00:00";break;
case 411: NewsDateTime="2017/12/08 15:30:00";break;
case 412: NewsDateTime="2017/12/11 17:00:00";break;
case 413: NewsDateTime="2017/12/12 12:00:00";break;
case 414: NewsDateTime="2017/12/12 15:30:00";break;
case 415: NewsDateTime="2017/12/12 21:00:00";break;
case 416: NewsDateTime="2017/12/13 15:30:00";break;
case 417: NewsDateTime="2017/12/13 17:30:00";break;
case 418: NewsDateTime="2017/12/13 21:00:00";break;
case 419: NewsDateTime="2017/12/13 21:30:00";break;
case 420: NewsDateTime="2017/12/13 22:00:00";break;
case 421: NewsDateTime="2017/12/14 10:30:00";break;
case 422: NewsDateTime="2017/12/14 14:45:00";break;
case 423: NewsDateTime="2017/12/14 15:30:00";break;
case 424: NewsDateTime="2017/12/18 12:00:00";break;
case 425: NewsDateTime="2017/12/19 11:00:00";break;
case 426: NewsDateTime="2017/12/19 15:30:00";break;
case 427: NewsDateTime="2017/12/20 17:00:00";break;
case 428: NewsDateTime="2017/12/20 17:30:00";break;
case 429: NewsDateTime="2017/12/21 15:30:00";break;
case 430: NewsDateTime="2017/12/22 15:30:00";break;
case 431: NewsDateTime="2017/12/22 17:00:00";break;
case 432: NewsDateTime="2017/12/27 17:00:00";break;
case 433: NewsDateTime="2017/12/28 18:00:00";break;




   }
 }
 else
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
                      
                       
                       NewsType = MySqlGetFieldAsString(Cursor, 3 ); // code
                       NewsCurrency = MySqlGetFieldAsString(Cursor, 2 ); // code
                       NewsDateTime = MySqlGetFieldAsDatetime(Cursor, 1 ); // code
                       
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
}


void ConvertEnumCurrToString(int EnumValue,string &ValueToChange)
{
   switch(EnumValue)
      {
         case 0: ValueToChange = "USD"; break;
         case 1: ValueToChange = "EUR"; break;
         case 2: ValueToChange = "JPY"; break;
         case 3: ValueToChange = "CAD"; break;
         case 4: ValueToChange = "GBP"; break;
         case 5: ValueToChange = "AUD"; break;
         case 6: ValueToChange = "NZD"; break;
      }
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



//This function is to post done trade in to database
void PostFinishedTrade()
{
   //connect mysql
   

       DB = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
       if (DB == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB);}
       string Query;
       Query = "INSERT INTO mysqlnewsea.newstrades(UserID, Curr, NewsDate,NewsType,Pips,Balance)VALUES (" + UserID + ", '" + NewsCurrency + "', '" + NewsDateTime + "','" + NewsType + "'," + CurrPips + "," + AccountBalance() + ");";
     // Query = "INSERT INTO mysqlnewsea.newstrades(UserID, Curr, NewsDate,NewsType,Pips,Balance)VALUES (" + 2 + ", '" + "TRY" + "', @" + "2018-08-06 13:30:00" + "@,'" + "testy" + "'," + 299 + "," + AccountBalance() + ");";
      
      
       bool test = MySqlExecute(DB, Query);
      
            MySqlDisconnect(DB);
          
 
}
