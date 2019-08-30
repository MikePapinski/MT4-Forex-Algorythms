//+------------------------------------------------------------------+
//|                                 ForexStrategyMasterStrategy1.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""



void Strategy2CheckStatus(
                          int &Strategy2Step, 
                          int &Strategy2TradeType, 
                          double Strategy2EMA3Period1H, 
                          double Strategy2EMA5Period1H, 
                          double Strategy2EMA15Period1H, 
                          double Strategy2EMA45Period1H,
                          int Strategy2GHL1H,
                          int Strategy2QTI1H,
                          double Strategy2EMA3Period15M, 
                          double Strategy2EMA5Period15M, 
                          double Strategy2EMA15Period15M, 
                          double Strategy2EMA45Period15M,
                          int Strategy2GHL15M,
                          int Strategy2QTI15M,
                          long Strategy2TPValue,
                          long Strategy2SLValue,
                          int Strategy2EMAFullTrend
                          )
{

   switch(Strategy2Step)
   {
      case 0: Strategy2Step0(Strategy2Step, 
                          Strategy2TradeType, 
                          Strategy2EMA3Period1H, 
                          Strategy2EMA5Period1H, 
                          Strategy2EMA15Period1H, 
                          Strategy2EMA45Period1H,
                          Strategy2GHL1H,
                          Strategy2QTI1H,
                          Strategy2EMA3Period15M, 
                          Strategy2EMA5Period15M, 
                          Strategy2EMA15Period15M, 
                          Strategy2EMA45Period15M,
                          Strategy2GHL15M,
                          Strategy2QTI15M,
                          Strategy2TPValue,
                          Strategy2SLValue,
                          Strategy2EMAFullTrend);break;
      
      case 1: Strategy2Step1(Strategy2Step, 
                          Strategy2TradeType, 
                          Strategy2EMA3Period1H, 
                          Strategy2EMA5Period1H, 
                          Strategy2EMA15Period1H, 
                          Strategy2EMA45Period1H,
                          Strategy2GHL1H,
                          Strategy2QTI1H,
                          Strategy2EMA3Period15M, 
                          Strategy2EMA5Period15M, 
                          Strategy2EMA15Period15M, 
                          Strategy2EMA45Period15M,
                          Strategy2GHL15M,
                          Strategy2QTI15M,
                          Strategy2TPValue,
                          Strategy2SLValue,
                          Strategy2EMAFullTrend);break;
      
      case 2: Strategy2Step2(Strategy2Step, 
                          Strategy2TradeType, 
                          Strategy2EMA3Period1H, 
                          Strategy2EMA5Period1H, 
                          Strategy2EMA15Period1H, 
                          Strategy2EMA45Period1H,
                          Strategy2GHL1H,
                          Strategy2QTI1H,
                          Strategy2EMA3Period15M, 
                          Strategy2EMA5Period15M, 
                          Strategy2EMA15Period15M, 
                          Strategy2EMA45Period15M,
                          Strategy2GHL15M,
                          Strategy2QTI15M,
                          Strategy2TPValue,
                          Strategy2SLValue,
                          Strategy2EMAFullTrend);break;
                          
      case 3: Strategy2Step3(Strategy2Step, 
                          Strategy2TradeType, 
                          Strategy2EMA3Period1H, 
                          Strategy2EMA5Period1H, 
                          Strategy2EMA15Period1H, 
                          Strategy2EMA45Period1H,
                          Strategy2GHL1H,
                          Strategy2QTI1H,
                          Strategy2EMA3Period15M, 
                          Strategy2EMA5Period15M, 
                          Strategy2EMA15Period15M, 
                          Strategy2EMA45Period15M,
                          Strategy2GHL15M,
                          Strategy2QTI15M,
                          Strategy2TPValue,
                          Strategy2SLValue,
                          Strategy2EMAFullTrend);break;
                          
     case 4: Strategy2Step4(Strategy2Step, 
                          Strategy2TradeType, 
                          Strategy2EMA3Period1H, 
                          Strategy2EMA5Period1H, 
                          Strategy2EMA15Period1H, 
                          Strategy2EMA45Period1H,
                          Strategy2GHL1H,
                          Strategy2QTI1H,
                          Strategy2EMA3Period15M, 
                          Strategy2EMA5Period15M, 
                          Strategy2EMA15Period15M, 
                          Strategy2EMA45Period15M,
                          Strategy2GHL15M,
                          Strategy2QTI15M,
                          Strategy2TPValue,
                          Strategy2SLValue,
                          Strategy2EMAFullTrend);break;      
                    
     
   
   }
}
//********************************************************************************************************
//******************************************STEPS FUNCTIONS***********************************************
//********************************************************************************************************
//Strategy 1 Step 0 Start ********************************************************************************
void Strategy2Step0(int &Strategy2Step, 
                          int &Strategy2TradeType, 
                          double Strategy2EMA3Period1H, 
                          double Strategy2EMA5Period1H, 
                          double Strategy2EMA15Period1H, 
                          double Strategy2EMA45Period1H,
                          int Strategy2GHL1H,
                          int Strategy2QTI1H,
                          double Strategy2EMA3Period15M, 
                          double Strategy2EMA5Period15M, 
                          double Strategy2EMA15Period15M, 
                          double Strategy2EMA45Period15M,
                          int Strategy2GHL15M,
                          int Strategy2QTI15M,
                          long Strategy2TPValue,
                          long Strategy2SLValue,
                          long Strategy2EMAFullTrend)
{
 
   //Buy criteria
   if(Strategy2EMAFullTrend==1 && iClose(Symbol(),PERIOD_H1,1) > Strategy2EMA3Period1H  && Strategy2QTI1H==1 && Strategy2GHL1H==1){Strategy2Step=1;Strategy2TradeType=1;}
   //Sell criteria
   else if(Strategy2EMAFullTrend==2 && iClose(Symbol(),PERIOD_H1,1) < Strategy2EMA3Period1H && Strategy2QTI1H==2 && Strategy2GHL1H==2){Strategy2Step=1;Strategy2TradeType=2;}
   else {Strategy2Step=0;Strategy2TradeType=0;}

 
}
//Strategy 1 Step 0 End ********************************************************************************


//Strategy 1 Step 1 Start ********************************************************************************
void Strategy2Step1(int &Strategy2Step, 
                          int &Strategy2TradeType, 
                          double Strategy2EMA3Period1H, 
                          double Strategy2EMA5Period1H, 
                          double Strategy2EMA15Period1H, 
                          double Strategy2EMA45Period1H,
                          int Strategy2GHL1H,
                          int Strategy2QTI1H,
                          double Strategy2EMA3Period15M, 
                          double Strategy2EMA5Period15M, 
                          double Strategy2EMA15Period15M, 
                          double Strategy2EMA45Period15M,
                          int Strategy2GHL15M,
                          int Strategy2QTI15M,
                          long Strategy2TPValue,
                          long Strategy2SLValue,
                          long Strategy2EMAFullTrend)
{
   //Buy
   if(Strategy2TradeType==1)
   {
      //check if setup voided
      if(Strategy2GHL1H != 1){Strategy2Step=0;Strategy2TradeType=0;}
      else if (Strategy2QTI1H != 1){Strategy2Step=0;Strategy2TradeType=0;}
      else if (Strategy2EMA3Period1H >= Bid){Strategy2Step=2;Strategy2TradeType=1;}
   }
   //Sell
   if(Strategy2TradeType==2)
   {
      //check if setup voided
      if(Strategy2GHL1H != 2){Strategy2Step=0;Strategy2TradeType=0;}
      else if (Strategy2QTI1H != 2){Strategy2Step=0;Strategy2TradeType=0;}
      else if (Strategy2EMA3Period1H <= Bid){Strategy2Step=2;Strategy2TradeType=2;}
   }   
}
//Strategy 1 Step 1 End ********************************************************************************


//Strategy 1 Step 2 Start ********************************************************************************
void Strategy2Step2(int &Strategy2Step, 
                          int &Strategy2TradeType, 
                          double Strategy2EMA3Period1H, 
                          double Strategy2EMA5Period1H, 
                          double Strategy2EMA15Period1H, 
                          double Strategy2EMA45Period1H,
                          int Strategy2GHL1H,
                          int Strategy2QTI1H,
                          double Strategy2EMA3Period15M, 
                          double Strategy2EMA5Period15M, 
                          double Strategy2EMA15Period15M, 
                          double Strategy2EMA45Period15M,
                          int Strategy2GHL15M,
                          int Strategy2QTI15M,
                          long Strategy2TPValue,
                          long Strategy2SLValue,
                          long Strategy2EMAFullTrend)
{
     //Buy
   if(Strategy2TradeType==1)
   {
      //check if setup voided
      if(Strategy2GHL1H != 1){Strategy2Step=0;Strategy2TradeType=0;}
      else if (Strategy2QTI1H != 1){Strategy2Step=0;Strategy2TradeType=0;}
     else if (iClose(Symbol(),PERIOD_M15,1) >  Strategy2EMA5Period15M  && Strategy2GHL15M==1 && Strategy2QTI15M==1){Strategy2Step=3;Strategy2TradeType=1;}
   } 
   //Sell
   if(Strategy2TradeType==2)
   {
      //check if setup voided
      if(Strategy2GHL1H != 2){Strategy2Step=0;Strategy2TradeType=0;}
      else if (Strategy2QTI1H != 2){Strategy2Step=0;Strategy2TradeType=0;}
      else if (iClose(Symbol(),PERIOD_M15,1) <  Strategy2EMA5Period15M && Strategy2GHL15M==2 && Strategy2QTI15M==2){Strategy2Step=3;Strategy2TradeType=2;}
   } 
  
  
  
}
//Strategy 1 Step 2 End ********************************************************************************


//Strategy 1 Step 3 Start ********************************************************************************
void Strategy2Step3(int &Strategy2Step, 
                          int &Strategy2TradeType, 
                          double Strategy2EMA3Period1H, 
                          double Strategy2EMA5Period1H, 
                          double Strategy2EMA15Period1H, 
                          double Strategy2EMA45Period1H,
                          int Strategy2GHL1H,
                          int Strategy2QTI1H,
                          double Strategy2EMA3Period15M, 
                          double Strategy2EMA5Period15M, 
                          double Strategy2EMA15Period15M, 
                          double Strategy2EMA45Period15M,
                          int Strategy2GHL15M,
                          int Strategy2QTI15M,
                          long Strategy2TPValue,
                          long Strategy2SLValue,
                          long Strategy2EMAFullTrend)
{
     //Buy
   if(Strategy2TradeType==1)
   {
   
      int BuyTicket=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,clrGreen);
      Strategy2Step = 4;
   
     
   } 
   //Sell
   if(Strategy2TradeType==2)
   {
     
     int SellTicket=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,clrRed);
     Strategy2Step = 4;
     
   } 
  
  
  
}
//Strategy 1 Step 3 End ********************************************************************************


//Strategy 1 Step 4 Start ********************************************************************************
void Strategy2Step4(int &Strategy2Step, 
                          int &Strategy2TradeType, 
                          double Strategy2EMA3Period1H, 
                          double Strategy2EMA5Period1H, 
                          double Strategy2EMA15Period1H, 
                          double Strategy2EMA45Period1H,
                          int Strategy2GHL1H,
                          int Strategy2QTI1H,
                          double Strategy2EMA3Period15M, 
                          double Strategy2EMA5Period15M, 
                          double Strategy2EMA15Period15M, 
                          double Strategy2EMA45Period15M,
                          int Strategy2GHL15M,
                          int Strategy2QTI15M,
                          long Strategy2TPValue,
                          long Strategy2SLValue,
                          long Strategy2EMAFullTrend)
{
     //Buy
   if(Strategy2TradeType==1)
   {
   
      if(Strategy2PointsProfit() > Strategy2TPValue){Strategy2Step=0;Strategy2TradeType=0;Strategy2CloseOrder();}
      else if(Strategy2PointsProfit() < (Strategy2SLValue*-1)){Strategy2Step=0;Strategy2TradeType=0;Strategy2CloseOrder();}
      else if(OrdersTotal()==0){Strategy2Step=0;Strategy2TradeType=0;}

   
     
   } 
   //Sell
   if(Strategy2TradeType==2)
   {
     
     if(Strategy2PointsProfit() > Strategy2TPValue){Strategy2Step=0;Strategy2TradeType=0;Strategy2CloseOrder();}
     else if(Strategy2PointsProfit() < (Strategy2SLValue*-1)){Strategy2Step=0;Strategy2TradeType=0;Strategy2CloseOrder();} 
     else if(OrdersTotal()==0){Strategy2Step=0;Strategy2TradeType=0;}

     
   } 
}
//Strategy 1 Step 4 End ********************************************************************************


void Strategy2CloseOrder()
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
               ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrSteelBlue);
               //-------------------------------------------------------------------------------------------------
              }
            if(OrderType()==OP_SELL)
              {
               //-------------------------------------------------------------------------------------------------
               double CloseSell=OrderClose(OrderTicket(),OrderLots(),Ask,0);
               //-------------------------------------------------------------------------------------------------
               ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrSteelBlue);
               //-------------------------------------------------------------------------------------------------
              }
           }
     }
  }
  
  long Strategy2PointsProfit()
{
 long ProfitInPoints;
   for(int i=0; i<OrdersTotal(); i++)
   {  
      
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      ProfitInPoints = ProfitInPoints + OrderProfit();
      
   
   }
   Comment(ProfitInPoints);
   return ProfitInPoints;
}