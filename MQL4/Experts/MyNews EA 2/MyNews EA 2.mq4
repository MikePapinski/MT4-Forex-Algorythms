//Load MySQL Connector
#import "..\libraries\MQLMySQL.dll"
   bool ValidateMe(string MyUserName, string MyPassword, string ProductID, string Mt4AccNumber, string ProductVersion);
   bool PushTradesToDB(int Ticket, string OpenTime, string Size, string Item, string OpenPrice, string SL, string TP, string CloseTime, string ClosePrice, string Commission, string Taxes, string Swap, string Profit, int ID_User, int ID_Product);
#import

//--- to download the xml
#import "urlmon.dll"
int URLDownloadToFileW(int pCaller,string szURL,string szFileName,int dwReserved,int Callback);
#import
//---
#property icon "icon1.ico"


#include <ForexFactory.mqh>
#include <MyNewsEA2_TradingSequence.mqh>
#include <MyNewsEA2_ChartTemplate.mqh>


//All Variables
string extern Username = "Jpapin";
string extern Password = "Password";
string Version = "1.2";
string ProductID = "1";
bool Validation = false;
string CurrentTradeCurrency="";
datetime TimeLeftToTrade=0;
int StepNumber=0;





//Load All data on start



int OnInit()
{
Validation=ValidateMe (Username,Password,ProductID,IntegerToString(AccountNumber()),Version);
   if(Validation==True)
   {
      Print("Changing chart template");
      ChangeChartFormat();
      Print("Updating News");
      UpdateForexFactory();
      Print("User verified");
      ExtractNewsData();
      Print("Forex Factory data reading");
      PopulateNewsOnChart(Username, CurrentTradeCurrency, TimeLeftToTrade,StepNumber);
      Print("Pushing trades history to Database");
       PushTradesHistory();
   }else{Comment("User not authorized");}
   
return(INIT_SUCCEEDED) ;
}


//Unload All Data on Exit  
void OnDeinit(const int reason){}





//Action to do on every tick
int start()
  {
  
   
   PopulateNewsOnChart(Username, CurrentTradeCurrency, TimeLeftToTrade,StepNumber);
   StartTradingSequence(StepNumber,TimeLeftToTrade,CurrentTradeCurrency);

   
   return 0;
  }



int PushTradesHistory()
 {
    
      int i,hstTotal=OrdersHistoryTotal();
  for(i=0;i<hstTotal;i++)
    {
     //---- check selection result
     if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false){Print("Access to history failed with error (",GetLastError(),")");break;}
    
    if(StringFind(OrderComment(),"MyNewsEA_")>-1){
    Print(OrderProfit() + " \\\\ " + TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS));
    PushTradesToDB(OrderTicket(), TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS), DoubleToStr(OrderLots(),2),  OrderSymbol(), DoubleToStr(OrderOpenPrice(),7), DoubleToStr(OrderStopLoss(),7), DoubleToStr(OrderTakeProfit(),7), TimeToStr(OrderCloseTime(),TIME_DATE|TIME_SECONDS), DoubleToStr(OrderClosePrice(),7), DoubleToStr(OrderCommission(),2), "0", DoubleToStr(OrderSwap(),2),  DoubleToStr(OrderProfit(),7), 2, 1);
      }
    }
    return 0;
}