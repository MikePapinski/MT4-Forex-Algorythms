//+------------------------------------------------------------------+
//|                                ForexStrategyMasterIndicators.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""




int CalculateQTI (int TimeFrame)
{
   if(iCustom(NULL,TimeFrame,"QTI",0,1)==2 && iCustom(NULL,TimeFrame,"QTI",1,1)==0 && iCustom(NULL,TimeFrame,"QTI",2,1)==0){return 1;}
   if(iCustom(NULL,TimeFrame,"QTI",0,1)==0 && iCustom(NULL,TimeFrame,"QTI",1,1)==2 && iCustom(NULL,TimeFrame,"QTI",2,1)==0){return 2;}
   if(iCustom(NULL,TimeFrame,"QTI",0,1)==0 && iCustom(NULL,TimeFrame,"QTI",1,1)==0 && iCustom(NULL,TimeFrame,"QTI",2,1)==2){return 0;}
   else return 0;
}

int CalculateGHL (int TimeFrame)
{
   if(iCustom(NULL,TimeFrame,"GHL",0,1)==2 && iCustom(NULL,TimeFrame,"GHL",1,1)==0 ){return 1;}
   if(iCustom(NULL,TimeFrame,"GHL",0,1)==0 && iCustom(NULL,TimeFrame,"GHL",1,1)==2 ){return 2;}
    else return 0;
}


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

