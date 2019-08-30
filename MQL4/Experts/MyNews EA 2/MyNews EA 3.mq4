//Load MySQL Connector
//#import "..\libraries\MQLMySQL.dll"
//   bool ValidateMe(string MyUserName, string MyPassword, string ProductID, string Mt4AccNumber, string ProductVersion);
//   bool PushTradesToDB(int Ticket, string OpenTime, string Size, string Item, string OpenPrice, string SL, string TP, string CloseTime, string ClosePrice, string Commission, string Taxes, string Swap, string Profit, int ID_User, int ID_Product);
//#import

//--- to download the xml
//#import "urlmon.dll"
//int URLDownloadToFileW(int pCaller,string szURL,string szFileName,int dwReserved,int Callback);
//#import
//---
#property icon "icon1.ico"


//#include <ForexFactory.mqh>
//#include <MyNewsEA2_TradingSequence.mqh>
#include <MyNewsEA2_ChartTemplate.mqh>


//All Variables
string extern Username = "Majki";
string extern Password = "Majki";
string Version = "1";
string ProductID = "1";
int UserID=NULL;
datetime UserMembershipExpire=NULL;
string CurrentTradeCurrency="";
datetime TimeLeftToTrade=0;
int StepNumber=0;

datetime LastTradeDate;
datetime UpcomingNewsDate;
string UpcomingNewsType;



//Load All data on start



int OnInit()
{
//Validation=ValidateMe (Username,Password,ProductID,IntegerToString(AccountNumber()),Version);
//   if(Validation==True)
//   {
//      Print("Changing chart template");
//      ChangeChartFormat();
//      Print("Updating News");
//      UpdateForexFactory();
//      Print("User verified");
//      ExtractNewsData();
//      Print("Forex Factory data reading");
//      PopulateNewsOnChart(Username, CurrentTradeCurrency, TimeLeftToTrade,StepNumber);
//      Print("Pushing trades history to Database");
//       PushTradesHistory();
//   }else{Comment("User not authorized");}
VerifyUserAccess();
GetNewsData();
PostTradeAPI();
PingAPI();
   
return(INIT_SUCCEEDED) ;
}


//Unload All Data on Exit  
void OnDeinit(const int reason){}





//Action to do on every tick
int start()
  {
  
   
   //PopulateNewsOnChart(Username, CurrentTradeCurrency, TimeLeftToTrade,StepNumber);
   //StartTradingSequence(StepNumber,TimeLeftToTrade,CurrentTradeCurrency);

   
   return 0;
  }



//int PushTradesHistory()
// {
//    
//  int i,hstTotal=OrdersHistoryTotal();
//  for(i=0;i<hstTotal;i++)
//    {
//     //---- check selection result
//     if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false){Print("Access to history failed with error (",GetLastError(),")");break;}
//    
//    if(StringFind(OrderComment(),"MyNewsEA_")>-1){
//    Print(OrderProfit() + " \\\\ " + TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS));
//    PushTradesToDB(OrderTicket(), TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS), DoubleToStr(OrderLots(),2),  OrderSymbol(), DoubleToStr(OrderOpenPrice(),7), DoubleToStr(OrderStopLoss(),7), DoubleToStr(OrderTakeProfit(),7), TimeToStr(OrderCloseTime(),TIME_DATE|TIME_SECONDS), DoubleToStr(OrderClosePrice(),7), DoubleToStr(OrderCommission(),2), "0", DoubleToStr(OrderSwap(),2),  DoubleToStr(OrderProfit(),7), 2, 1);
//      }
//    }
//    return 0;
//}


string ConnectAPI(string UrlString)
{
   string finalmsg = "Error";
   string cookie=NULL,headers;
   char post[],result[];
   int res;
   int timeout=5000;
//--- to enable access to the server, you should add URL 
//--- in the list of allowed URLs (Main Menu->Tools->Options, tab "Expert Advisors"):
   string url=UrlString;//check if its http or https
//--- Reset the last error code
   ResetLastError();
//--- Loading a html page from Google Finance
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
//--- Checking errors
   if(res==-1)
     {
      finalmsg="Divergencefx.com not whitelisted";
      MessageBox("Add the address 'DivergenceFX' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
     }
   else
     {
      int tit=ArraySize(result)-1;
      string html="";
      for(int xx=0;xx<=tit;xx++)
       {
       html=html+CharToStr(result[xx]);
       }
     finalmsg=html;
     //BNC_API_RESPONSE=html;
     }    
   return finalmsg;
}

bool VerifyUserAccess()
{
   bool ValidationStatus = False;
   string squery = ("http://divergencefx.gear.host/API/VerifyUser?KEY=TempKey123&UserName=" + Username + "&UserPassword=" + Password + "&EAversion=" + Version + "&EaID=" + ProductID);
   string response = ConnectAPI(squery);
   string to_split=response;  
   string sep=":";             
   ushort u_sep;                 
   string result[];           
   u_sep=StringGetCharacter(sep,0);
   int k=StringSplit(to_split,u_sep,result);
   if(result[0]=="Authenticated")
   {  
      UserID=result[1];
      string StrDateTime=result[2];
      sep=".";                // A separator as a character
      string StrD[];               // An array to get strings
      u_sep=StringGetCharacter(sep,0);
      k=StringSplit(StrDateTime,u_sep,StrD);
      UserMembershipExpire = StrToTime(StrD[2]+"."+StrD[1]+"."+StrD[0]);
      
      string LastTradeDateToSplit = result[3];
      sep=".";                // A separator as a character
      string StrDtrades[];               // An array to get strings
      u_sep=StringGetCharacter(sep,0);
      k=StringSplit(LastTradeDateToSplit,u_sep,StrDtrades);
      LastTradeDate = StrToTime(StrDtrades[2]+"."+StrDtrades[1]+"."+StrDtrades[0]+" "+StrDtrades[3]+":"+StrDtrades[4]+":"+StrDtrades[5]);
      
      
      ValidationStatus = True;
   }
   else
   {
      MessageBox(response);
      ValidationStatus = False;
   }
   
   return ValidationStatus;

}

datetime GetNewsData()
{  
   string Curr1 = StringSubstr(Symbol(),0,3);
   string Curr2 = StringSubstr(Symbol(),3,3);
   datetime FinalDate = NULL;
   string squery = ("http://divergencefx.gear.host/API/GetNewsEA?KEY=TempKey123&CurrencyCode1="+Curr1+"&CurrencyCode2="+Curr2);
   string response = ConnectAPI(squery);
   if(StringSubstr(response,0,1)=="I" || StringSubstr(response,0,1)=="N")
   {  
      FinalDate = NULL;
   }
   else
   {
      string to_split=response;  
      string sep="/";             
      ushort u_sep;                 
      string result[];           
      u_sep=StringGetCharacter(sep,0);
      int k=StringSplit(to_split,u_sep,result);
      UpcomingNewsType=result[1];
      string SpltN[];
      sep=".";
      u_sep=StringGetCharacter(sep,0);
      k=StringSplit(result[0],u_sep,SpltN);
      UpcomingNewsDate=StrToTime(SpltN[2]+"."+SpltN[1]+"."+SpltN[0] + " " + SpltN[3] + ":" + SpltN[4]);
      FinalDate=UpcomingNewsDate;
   }
   return FinalDate;
}

int PingAPI()
{
   string squery = ("http://divergencefx.gear.host/API/PingFromEA?KEY=TempKey123&ID_User="+UserID+"&Bname="+AccountCompany()+"&Baccount="+AccountNumber());
   string response = ConnectAPI(squery);
   if(response!="Success")
   {  
      MessageBox("Problem with DivergenceFX connection. Please check your internet connection.");
   }
   return 0;
}


int PostTradeAPI()
{
    int i,hstTotal=OrdersHistoryTotal();
  for(i=0;i<hstTotal;i++)
    {
     //---- check selection result
     if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false){Print("Access to history failed with error (",GetLastError(),")");break;}
    
    if(StringFind(OrderComment(),"MyNewsEA_")>-1 && OrderCloseTime()>LastTradeDate){
    Print(OrderProfit() + " \\\\ " + TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS));
    Print(  DoubleToStr(OrderSwap(),2),  DoubleToStr(OrderProfit(),7), 2, 1);
      
    
    string squery = "http://divergencefx.gear.host/API/PostTradesEA?KEY=TempKey123";
    squery = squery + "&ID_User=" + UserID;
    squery = squery + "&ID_EA=" + ProductID;
    squery = squery + "&Ticket=" + OrderTicket();
    squery = squery + "&OpenTime=" + TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS);
    squery = squery + "&Size=" + DoubleToStr(OrderLots(),2);
    squery = squery + "&Item=" + OrderSymbol();
    squery = squery + "&OpenPrice=" + DoubleToStr(OrderOpenPrice(),7);
    squery = squery + "&SL=" + DoubleToStr(OrderStopLoss(),7);
    squery = squery + "&TP=" + DoubleToStr(OrderTakeProfit(),7);
    squery = squery + "&CloseTime=" + TimeToStr(OrderCloseTime(),TIME_DATE|TIME_SECONDS);
    squery = squery + "&ClosePrice=" + DoubleToStr(OrderClosePrice(),7);
    squery = squery + "&Commission=" + DoubleToStr(OrderCommission(),2);
    squery = squery + "&Taxes=" + "0";
    squery = squery + "&Swap=" + DoubleToStr(OrderSwap(),2);
    squery = squery + "&Profit=" + DoubleToStr(OrderProfit(),7);
    squery = squery + "&AccountType=" + "1";

      string newresponse = ConnectAPI(squery);
      if(newresponse!="Success")
      {  
         MessageBox("Problem with DivergenceFX connection. Please check your internet connection.");
      }
                                 
      }
    }
    return 0;
}