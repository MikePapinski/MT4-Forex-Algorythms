//+------------------------------------------------------------------+
//|                                          SafeZone.mq4 |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""
#property version   "1.00"

input double TP    =50;

// User Settings
double PriorDailyHigh =0;
double PriorDailyLow =0;
int tradingSTEP = 0;


//Lot size
double LotSize = 0;
int TradeTypes = 0;


//PIvots variables
long test=0;
string var1=0;
string var2=0;
double lastS1=0;
double lastS2=0;
double lastR1=0;
double lastR2=0;



// Include
#include <SafeZoneDashboard.mqh>
#include <DftChartTemplate.mqh>
#include <PivotsDraw.mqh>
#include <SafeZoneTradeManagement.mqh>

#import "DLLSample.dll"
int    GetIntValue(int);
double GetDoubleValue(double);
string GetStringValue(string);
double GetArrayItemValue(double &arr[],int,int);
bool   SetArrayItemValue(double &arr[],int,int,double);
double GetRatesItemValue(double &rates[][6],int,int,int);



//Dll1.dll
//+------------------------------------------------------------------+
//| START EA                                                         |
//+------------------------------------------------------------------+

void init()
{
//ChartApplyTemplate(0,"forex strategy master");
DrawDashboard();
ChangeChartFormat();
var1=TimeToStr(TimeCurrent(),TIME_DATE);
var2=TimeToStr(TimeCurrent(),TIME_DATE);


}

void start()
{

//Comment(GetStringValue("test DLL"));

PriorDailyHigh =iHigh(Symbol(),PERIOD_D1,1);
PriorDailyLow =iLow(Symbol(),PERIOD_D1,1);
LotSize = (AccountBalance()/100000);


//Update Dashboard
UpdateDashboard(PriorDailyHigh,PriorDailyLow);

//Draw pivots
DrawPivots(var1, test);

//Manage trades
TradeManagement(tradingSTEP,TradeTypes,lastS1,lastS2,lastR1,lastR2,var2,LotSize);

}



void deinit()
{ 

}



