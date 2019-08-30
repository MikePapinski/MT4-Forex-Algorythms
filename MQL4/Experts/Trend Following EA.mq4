//+------------------------------------------------------------------+
//|                                           Trend Following EA.mq4 |
//|                                                             Mike |
//|                                                                  |
//+------------------------------------------------------------------+

#property copyright "Mike"
#property link      ""
#property version   "1.00"
#property strict

//Import & Include section
#include <DftChartTemplate.mqh>
#include <TrendFollowingDashboard.mqh>
#include <TrendFollowingFunctions.mqh>

//Define public variables
string ActiveTrend = "";
int TradingStep = 0;
int StepTrend = 0;

//Extern variables
extern int TP = 100;
extern int SL = 100;
extern double LotSize = 0.1;





//Get Timeframes

int OnInit()
  {
//---Get Chart Template & Dashboard
   ChangeChartFormat();
   DrawDashboard();
   UpdateDashboard(ActiveTrend,TradingStep);
   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert Start function                                             |
//+------------------------------------------------------------------+
int start()
  {

   
  //Deifine Acive Trend 
  if(CalculateMainEMATrend(Period())==1){ActiveTrend="Up Trend";}
   else if(CalculateMainEMATrend(Period())==2){ActiveTrend="Down Trend";}  
   else{ActiveTrend="No Trend";}
   
   
   //Manage trade steps
   StepsManagement(TradingStep,ActiveTrend,StepTrend,TP,SL,LotSize );

  
  //Update Dashboard
   UpdateDashboard(ActiveTrend,TradingStep);
  

   
   return 0;
  }
//+------------------------------------------------------------------+
