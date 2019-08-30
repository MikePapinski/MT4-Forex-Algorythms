//+------------------------------------------------------------------+
//|                                          ForexStrategyMaster.mq4 |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""
#property version   "1.00"

input double TP    =50;
input double SL         =1;



// User Settings
double PriorDailyHigh =0;
double PriorDailyLow =0;
bool OpenedTrades =false;
int tradingSTEP = 0;



//Lot size
double LotSize = 0;

// Include
#include <DailyBreakoutDashboard.mqh>
#include <DailyBreakoutTradeManagement.mqh>

//+------------------------------------------------------------------+
//| START EA                                                         |
//+------------------------------------------------------------------+

void init()
{
//ChartApplyTemplate(0,"forex strategy master");
DrawDashboard();



}

void start()
{

PriorDailyHigh =iHigh(Symbol(),PERIOD_D1,1);
PriorDailyLow =iLow(Symbol(),PERIOD_D1,1);
LotSize = (AccountBalance()/5000);


//Update Dashboard
UpdateDashboard(PriorDailyHigh,PriorDailyLow);

//Check for trades
TradeManagement (tradingSTEP,OpenedTrades,LotSize,PriorDailyHigh,PriorDailyLow,TP,SL);

}



void deinit()
{ 

}


