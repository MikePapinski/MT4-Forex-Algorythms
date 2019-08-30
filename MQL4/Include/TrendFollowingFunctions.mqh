//+------------------------------------------------------------------+
//|                                      TrendFollowingFunctions.mqh |
//|                                                             Mike |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Mike"
#property link      "https://www.mql5.com"
#property strict



double CalculateEMA3 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 3,1, MODE_EMA, PRICE_CLOSE, 1),5);
}


double CalculateEMA5 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 5,3, MODE_EMA, PRICE_CLOSE, 1),5);
}

double CalculateCurrnetBarEMA3 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 3,1, MODE_EMA, PRICE_CLOSE, 0),5);
}


double CalculateCurrnetBarEMA5 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 5,3, MODE_EMA, PRICE_CLOSE,0),5);
}


double CalculateEMA15 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 15,3, MODE_EMA, PRICE_CLOSE, 1),5);
}


double CalculateEMA45 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 45,3, MODE_EMA, PRICE_CLOSE, 1),5);
}

int CalculateAllEMATrend (int TimeFrame)
{

   if(Bid > CalculateEMA3(TimeFrame) && CalculateEMA3(TimeFrame) > CalculateEMA5(TimeFrame) && CalculateEMA5(TimeFrame) > CalculateEMA15(TimeFrame) && CalculateEMA15(TimeFrame) > CalculateEMA45(TimeFrame)){return 1;}
   else if(Ask < CalculateEMA3(TimeFrame) && CalculateEMA3(TimeFrame) < CalculateEMA5(TimeFrame) && CalculateEMA5(TimeFrame) < CalculateEMA15(TimeFrame) && CalculateEMA15(TimeFrame) < CalculateEMA45(TimeFrame)){return 2;}  
   else return 0;
}

int CalculateMainEMATrend (int TimeFrame)
{

   if( CalculateEMA15(TimeFrame) > CalculateEMA45(TimeFrame)){return 1;}
   else if( CalculateEMA15(TimeFrame) < CalculateEMA45(TimeFrame)){return 2;}  
   else return 0;
}

long GetSmallerTimeframe ( int TimeFrame)
{
   long SmallerTimeFrame = 0;
   
   switch (TimeFrame)
   {
       case 5: SmallerTimeFrame = 1;break;
       case 15: SmallerTimeFrame = 5;break;
       case 30: SmallerTimeFrame = 15;break;
       case 60: SmallerTimeFrame = 15;break;
       case 240: SmallerTimeFrame = 60;break;
       case 1440:SmallerTimeFrame = 240 ;break;
   }
   return SmallerTimeFrame;
}



// Manage trades
void StepsManagement(int &TradingStep, string ActiveTrend, int &StepTrend, int TP, int  SL, double LotSize)
{

   switch(TradingStep)
   {
      case 0: ActionStep0 (TradingStep,ActiveTrend,StepTrend ); break;
      case 1: ActionStep1 (TradingStep,ActiveTrend,StepTrend ); break;
      case 2: ActionStep2 (TradingStep,ActiveTrend,StepTrend ); break;
      case 3: ActionStep3 (TradingStep,ActiveTrend,StepTrend, LotSize ); break;
      case 4: ActionStep4 (TradingStep,ActiveTrend,StepTrend, TP, SL ); break;
      case 5: ActionStep5 (TradingStep,ActiveTrend,StepTrend ); break;
      case 6: ActionStep6 (TradingStep,ActiveTrend,StepTrend ); break;
   }
}

void ActionStep0 (int &TradingStep, string ActiveTrend, int &StepTrend)
{
//Define trend
if(CalculateAllEMATrend(Period())==1){StepTrend=1;TradingStep=1;}
else if (CalculateAllEMATrend(Period())==2){StepTrend=2;TradingStep=1;}
else {TradingStep=0;StepTrend=0;}


}
void ActionStep1 (int &TradingStep, string ActiveTrend, int &StepTrend)
{
if (CalculateMainEMATrend(Period())!= StepTrend){TradingStep=0;}
else if(StepTrend==1 && CalculateEMA5 (Period()) > Bid && CalculateEMA5 (Period()) > Ask){TradingStep=2;}
else if(StepTrend==2 && CalculateEMA5 (Period()) < Bid && CalculateEMA5 (Period()) < Ask){TradingStep=2;}

}

void ActionStep2 (int &TradingStep, string ActiveTrend, int &StepTrend)
{
if (CalculateMainEMATrend(Period())!= StepTrend){TradingStep=0;}
else if(StepTrend==1 && CalculateEMA5 (GetSmallerTimeframe(Period())) < Bid && CalculateEMA5 (GetSmallerTimeframe(Period())) < Ask && CalculateEMA3 (GetSmallerTimeframe(Period())) < Bid && CalculateEMA3 (GetSmallerTimeframe(Period())) < Ask && CalculateEMA15 (GetSmallerTimeframe(Period())) < Bid && CalculateEMA15 (GetSmallerTimeframe(Period())) < Ask && CalculateEMA45 (GetSmallerTimeframe(Period())) < Bid && CalculateEMA45 (GetSmallerTimeframe(Period())) < Ask){TradingStep=3;}
else if(StepTrend==2 && CalculateEMA5 (GetSmallerTimeframe(Period())) > Bid && CalculateEMA5 (GetSmallerTimeframe(Period())) > Ask && CalculateEMA3 (GetSmallerTimeframe(Period())) > Bid && CalculateEMA3 (GetSmallerTimeframe(Period())) > Ask && CalculateEMA15 (GetSmallerTimeframe(Period())) > Bid && CalculateEMA15 (GetSmallerTimeframe(Period())) > Ask && CalculateEMA45 (GetSmallerTimeframe(Period())) > Bid && CalculateEMA45 (GetSmallerTimeframe(Period())) > Ask){TradingStep=3;}


}

void ActionStep3 (int &TradingStep, string ActiveTrend, int &StepTrend, double LotSize)
{
if (CalculateMainEMATrend(Period())!= StepTrend){TradingStep=0;}
else if(StepTrend==1){ int BuyTicket=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);TradingStep=4;}
else if(StepTrend==2){ int SellTicket=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);TradingStep=4;}


}

void ActionStep4 (int &TradingStep, string ActiveTrend, int &StepTrend, int TP, int  SL)
{
string TradeTypeString = "";


if (StepTrend==1){TradeTypeString = "BUY";}
else if (StepTrend==2){TradeTypeString = "SELL";}



if(PointsProfit() > TP){P_L_TextCreate(NormalizeDouble((AccountEquity()-AccountBalance()),2),TradeTypeString);CloseOrder();TradingStep=0;}
else if(PointsProfit() < (SL*(-1))){P_L_TextCreate(NormalizeDouble((AccountEquity()-AccountBalance()),2),TradeTypeString);CloseOrder();TradingStep=0;}


}

void ActionStep5 (int &TradingStep, string ActiveTrend, int &StepTrend)
{
TradingStep=6;
}

void ActionStep6 (int &TradingStep, string ActiveTrend, int &StepTrend)
{

TradingStep=0;
}


 double PointsProfit()
{
int  ProfitInPoints;
   for(int i=0; i<OrdersTotal(); i++)
   {  
      
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
       ProfitInPoints = ProfitInPoints + OrderProfit();
      
   
   }
   Comment(ProfitInPoints);
   return (ProfitInPoints);
}


void CloseOrder()
  {
//Close Long Order
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY)
              {
               //-------------------------------------------------------------------------------------------------
               double CloseBuy=OrderClose(OrderTicket(),OrderLots(),Bid,0);
               //-------------------------------------------------------------------------------------------------
              // ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrSteelBlue);
               //-------------------------------------------------------------------------------------------------
              }
            if(OrderType()==OP_SELL)
              {
               //-------------------------------------------------------------------------------------------------
               double CloseSell=OrderClose(OrderTicket(),OrderLots(),Ask,0);
               //-------------------------------------------------------------------------------------------------
              // ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrSteelBlue);
               //-------------------------------------------------------------------------------------------------
              }
           }
     }
  }
  
  
  

//+------------------------------------------------------------------+
//| Creating Text object                                             |
//+------------------------------------------------------------------+
bool P_L_TextCreate(double P_and_L, int TradeType)
{
  string name = "P&L-"+TimeCurrent();
  string Recname = "P&L-REC-"+TimeCurrent();
  int chart_ID = 0;
  
  color BoxColor = clrBlack;
  double BoxPrice =0;
  

  if(P_and_L>0)
  {
   BoxColor =clrGreen;
  }
  else
  {
   BoxColor =clrRed;
  }
  string texttype ="";
  if(TradeType==1)
  {
   texttype = ": BUY";
  }
  else if(TradeType==2)
  {
      texttype = ": Sell";
   }
   ObjectCreate(chart_ID,Recname ,OBJ_TEXT,0,TimeCurrent(),Ask);
   ObjectCreate(chart_ID,name ,OBJ_TEXT,0,TimeCurrent(),Ask);
   
  // ObjectCreate(chart_ID,Recname,OBJ_RECTANGLE,0,TimeCurrent(),BoxPrice,TimeCurrent()+(TimeCurrent()-iTime(Symbol(),PERIOD_H1,7)),BoxPrice-(60*Point));
   
   ObjectSetText(Recname, "gggggg", 13, "Webdings");
   ObjectSetInteger(chart_ID,Recname,OBJPROP_COLOR,BoxColor);
   ObjectSetInteger(chart_ID,Recname,OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
   //ObjectSetInteger(chart_ID,Recname,OBJPROP_COLOR,BoxColor);
   
   
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,DoubleToStr(NormalizeDouble(P_and_L,2),2) + " $" + texttype);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,"Arial");
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,10);
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,0.0);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clrWhiteSmoke);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,true);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0);
   return(true);
  }
  
  //+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeTextEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }