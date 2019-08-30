//+------------------------------------------------------------------+
//|                                         Pivots |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""
#property version   "1.00"




// User Settings
double PriorDailyHigh =0;
double PriorDailyLow =0;
bool OpenedTrades =false;
int tradingSTEP = 0;

datetime date1 = TimeCurrent();
datetime date2 = TimeCurrent();
double price1 = 0;
double price2 = 0;

long test=0;

//Lot size
double LotSize = 0;
string var1="";
//Include
#include <PivotsDraw.mqh>


//+------------------------------------------------------------------+
//| START EA                                                         |
//+------------------------------------------------------------------+

void init()
{


var1=TimeToStr(TimeCurrent(),TIME_DATE);

}

void start()
{


LotSize = (AccountBalance()/5000);


 
DrawPivots(var1, test);

}



void deinit()
{ 

}



