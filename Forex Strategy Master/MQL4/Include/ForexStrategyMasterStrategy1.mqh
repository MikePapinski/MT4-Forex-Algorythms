//+------------------------------------------------------------------+
//|                                 ForexStrategyMasterStrategy1.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""



void Strategy1CheckStatus(
                          int &Strategy1Step, 
                          int &Strategy1TradeType, 
                          double Strategy1EMA3Period1H, 
                          double Strategy1EMA5Period1H, 
                          double Strategy1EMA15Period1H, 
                          double Strategy1EMA45Period1H,
                          int Strategy1GHL1H,
                          int Strategy1QTI1H,
                          double Strategy1EMA3Period15M, 
                          double Strategy1EMA5Period15M, 
                          double Strategy1EMA15Period15M, 
                          double Strategy1EMA45Period15M,
                          int Strategy1GHL15M,
                          int Strategy1QTI15M,
                          double Strategy1TPValue,
                          double Strategy1SLValue,
                          int Strategy1EMAFullTrend
                          )
{

   switch(Strategy1Step)
   {
      case 0: Strategy1Step0(Strategy1Step, 
                          Strategy1TradeType, 
                          Strategy1EMA3Period1H, 
                          Strategy1EMA5Period1H, 
                          Strategy1EMA15Period1H, 
                          Strategy1EMA45Period1H,
                          Strategy1GHL1H,
                          Strategy1QTI1H,
                          Strategy1EMA3Period15M, 
                          Strategy1EMA5Period15M, 
                          Strategy1EMA15Period15M, 
                          Strategy1EMA45Period15M,
                          Strategy1GHL15M,
                          Strategy1QTI15M,
                          Strategy1TPValue,
                          Strategy1SLValue,
                          Strategy1EMAFullTrend);break;
      
      case 1: Strategy1Step1(Strategy1Step, 
                          Strategy1TradeType, 
                          Strategy1EMA3Period1H, 
                          Strategy1EMA5Period1H, 
                          Strategy1EMA15Period1H, 
                          Strategy1EMA45Period1H,
                          Strategy1GHL1H,
                          Strategy1QTI1H,
                          Strategy1EMA3Period15M, 
                          Strategy1EMA5Period15M, 
                          Strategy1EMA15Period15M, 
                          Strategy1EMA45Period15M,
                          Strategy1GHL15M,
                          Strategy1QTI15M,
                          Strategy1TPValue,
                          Strategy1SLValue,
                          Strategy1EMAFullTrend);break;
      
      case 2: Strategy1Step2(Strategy1Step, 
                          Strategy1TradeType, 
                          Strategy1EMA3Period1H, 
                          Strategy1EMA5Period1H, 
                          Strategy1EMA15Period1H, 
                          Strategy1EMA45Period1H,
                          Strategy1GHL1H,
                          Strategy1QTI1H,
                          Strategy1EMA3Period15M, 
                          Strategy1EMA5Period15M, 
                          Strategy1EMA15Period15M, 
                          Strategy1EMA45Period15M,
                          Strategy1GHL15M,
                          Strategy1QTI15M,
                          Strategy1TPValue,
                          Strategy1SLValue,
                          Strategy1EMAFullTrend);break;
                          
      case 3: Strategy1Step3(Strategy1Step, 
                          Strategy1TradeType, 
                          Strategy1EMA3Period1H, 
                          Strategy1EMA5Period1H, 
                          Strategy1EMA15Period1H, 
                          Strategy1EMA45Period1H,
                          Strategy1GHL1H,
                          Strategy1QTI1H,
                          Strategy1EMA3Period15M, 
                          Strategy1EMA5Period15M, 
                          Strategy1EMA15Period15M, 
                          Strategy1EMA45Period15M,
                          Strategy1GHL15M,
                          Strategy1QTI15M,
                          Strategy1TPValue,
                          Strategy1SLValue,
                          Strategy1EMAFullTrend);break;
                          
     case 4: Strategy1Step4(Strategy1Step, 
                          Strategy1TradeType, 
                          Strategy1EMA3Period1H, 
                          Strategy1EMA5Period1H, 
                          Strategy1EMA15Period1H, 
                          Strategy1EMA45Period1H,
                          Strategy1GHL1H,
                          Strategy1QTI1H,
                          Strategy1EMA3Period15M, 
                          Strategy1EMA5Period15M, 
                          Strategy1EMA15Period15M, 
                          Strategy1EMA45Period15M,
                          Strategy1GHL15M,
                          Strategy1QTI15M,
                          Strategy1TPValue,
                          Strategy1SLValue,
                          Strategy1EMAFullTrend);break;      
                    
     
   
   }
}
//********************************************************************************************************
//******************************************STEPS FUNCTIONS***********************************************
//********************************************************************************************************
//Strategy 1 Step 0 Start ********************************************************************************
void Strategy1Step0(int &Strategy1Step, 
                          int &Strategy1TradeType, 
                          double Strategy1EMA3Period1H, 
                          double Strategy1EMA5Period1H, 
                          double Strategy1EMA15Period1H, 
                          double Strategy1EMA45Period1H,
                          int Strategy1GHL1H,
                          int Strategy1QTI1H,
                          double Strategy1EMA3Period15M, 
                          double Strategy1EMA5Period15M, 
                          double Strategy1EMA15Period15M, 
                          double Strategy1EMA45Period15M,
                          int Strategy1GHL15M,
                          int Strategy1QTI15M,
                          double Strategy1TPValue,
                          double Strategy1SLValue,
                          double Strategy1EMAFullTrend)
{
 
   //Buy criteria
   if(Strategy1EMAFullTrend==1 && iClose(Symbol(),PERIOD_H1,1) > Strategy1EMA3Period1H  && Strategy1QTI1H==1 && Strategy1GHL1H==1){Strategy1Step=1;Strategy1TradeType=1;}
   //Sell criteria
   else if(Strategy1EMAFullTrend==2 && iClose(Symbol(),PERIOD_H1,1) < Strategy1EMA3Period1H && Strategy1QTI1H==2 && Strategy1GHL1H==2){Strategy1Step=1;Strategy1TradeType=2;}
   else {Strategy1Step=0;Strategy1TradeType=0;}

 
}
//Strategy 1 Step 0 End ********************************************************************************


//Strategy 1 Step 1 Start ********************************************************************************
void Strategy1Step1(int &Strategy1Step, 
                          int &Strategy1TradeType, 
                          double Strategy1EMA3Period1H, 
                          double Strategy1EMA5Period1H, 
                          double Strategy1EMA15Period1H, 
                          double Strategy1EMA45Period1H,
                          int Strategy1GHL1H,
                          int Strategy1QTI1H,
                          double Strategy1EMA3Period15M, 
                          double Strategy1EMA5Period15M, 
                          double Strategy1EMA15Period15M, 
                          double Strategy1EMA45Period15M,
                          int Strategy1GHL15M,
                          int Strategy1QTI15M,
                          double Strategy1TPValue,
                          double Strategy1SLValue,
                          double Strategy1EMAFullTrend)
{
   //Buy
   if(Strategy1TradeType==1)
   {
      //check if setup voided
      if(Strategy1GHL1H != 1){Strategy1Step=0;Strategy1TradeType=0;}
      else if (Strategy1QTI1H != 1){Strategy1Step=0;Strategy1TradeType=0;}
      else if (Strategy1EMA5Period1H >= Bid){Strategy1Step=2;Strategy1TradeType=1;}
   }
   //Sell
   if(Strategy1TradeType==2)
   {
      //check if setup voided
      if(Strategy1GHL1H != 2){Strategy1Step=0;Strategy1TradeType=0;}
      else if (Strategy1QTI1H != 2){Strategy1Step=0;Strategy1TradeType=0;}
      else if (Strategy1EMA5Period1H <= Bid){Strategy1Step=2;Strategy1TradeType=2;}
   }   
}
//Strategy 1 Step 1 End ********************************************************************************


//Strategy 1 Step 2 Start ********************************************************************************
void Strategy1Step2(int &Strategy1Step, 
                          int &Strategy1TradeType, 
                          double Strategy1EMA3Period1H, 
                          double Strategy1EMA5Period1H, 
                          double Strategy1EMA15Period1H, 
                          double Strategy1EMA45Period1H,
                          int Strategy1GHL1H,
                          int Strategy1QTI1H,
                          double Strategy1EMA3Period15M, 
                          double Strategy1EMA5Period15M, 
                          double Strategy1EMA15Period15M, 
                          double Strategy1EMA45Period15M,
                          int Strategy1GHL15M,
                          int Strategy1QTI15M,
                          double Strategy1TPValue,
                          double Strategy1SLValue,
                          double Strategy1EMAFullTrend)
{
     //Buy
   if(Strategy1TradeType==1)
   {
      //check if setup voided
      if(Strategy1GHL1H != 1){Strategy1Step=0;Strategy1TradeType=0;}
      else if (Strategy1QTI1H != 1){Strategy1Step=0;Strategy1TradeType=0;}
     else if (iClose(Symbol(),PERIOD_M15,1) >  Strategy1EMA3Period15M && iClose(Symbol(),PERIOD_M15,1) >  Strategy1EMA5Period15M && iClose(Symbol(),PERIOD_M15,1) >  Strategy1EMA15Period15M && iClose(Symbol(),PERIOD_M15,1)  >  Strategy1EMA45Period15M && Strategy1GHL15M==1 && Strategy1QTI15M==1){Strategy1Step=3;Strategy1TradeType=1;}
   } 
   //Sell
   if(Strategy1TradeType==2)
   {
      //check if setup voided
      if(Strategy1GHL1H != 2){Strategy1Step=0;Strategy1TradeType=0;}
      else if (Strategy1QTI1H != 2){Strategy1Step=0;Strategy1TradeType=0;}
      else if (iClose(Symbol(),PERIOD_M15,1) <  Strategy1EMA3Period15M && iClose(Symbol(),PERIOD_M15,1) <  Strategy1EMA5Period15M && iClose(Symbol(),PERIOD_M15,1) <  Strategy1EMA15Period15M && iClose(Symbol(),PERIOD_M15,1)  <  Strategy1EMA45Period15M && Strategy1GHL15M==2 && Strategy1QTI15M==2){Strategy1Step=3;Strategy1TradeType=2;}
   } 
  
  
  
}
//Strategy 1 Step 2 End ********************************************************************************


//Strategy 1 Step 3 Start ********************************************************************************
void Strategy1Step3(int &Strategy1Step, 
                          int &Strategy1TradeType, 
                          double Strategy1EMA3Period1H, 
                          double Strategy1EMA5Period1H, 
                          double Strategy1EMA15Period1H, 
                          double Strategy1EMA45Period1H,
                          int Strategy1GHL1H,
                          int Strategy1QTI1H,
                          double Strategy1EMA3Period15M, 
                          double Strategy1EMA5Period15M, 
                          double Strategy1EMA15Period15M, 
                          double Strategy1EMA45Period15M,
                          int Strategy1GHL15M,
                          int Strategy1QTI15M,
                          double Strategy1TPValue,
                          double Strategy1SLValue,
                          double Strategy1EMAFullTrend)
{
     //Buy
   if(Strategy1TradeType==1)
   {
   
      int BuyTicket=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);
      Strategy1Step = 4;
   
     
   } 
   //Sell
   if(Strategy1TradeType==2)
   {
     
     int SellTicket=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);
     Strategy1Step = 4;
     
   } 
  
  
  
}
//Strategy 1 Step 3 End ********************************************************************************


//Strategy 1 Step 4 Start ********************************************************************************
void Strategy1Step4(int &Strategy1Step, 
                          int &Strategy1TradeType, 
                          double Strategy1EMA3Period1H, 
                          double Strategy1EMA5Period1H, 
                          double Strategy1EMA15Period1H, 
                          double Strategy1EMA45Period1H,
                          int Strategy1GHL1H,
                          int Strategy1QTI1H,
                          double Strategy1EMA3Period15M, 
                          double Strategy1EMA5Period15M, 
                          double Strategy1EMA15Period15M, 
                          double Strategy1EMA45Period15M,
                          int Strategy1GHL15M,
                          int Strategy1QTI15M,
                          double Strategy1TPValue,
                          double Strategy1SLValue,
                          double Strategy1EMAFullTrend)
{
     //Buy
   if(Strategy1TradeType==1)
   {
   
      if(Strategy1PointsProfit() > Strategy1TPValue){Strategy1Step=0;Strategy1TradeType=0;Strategy1CloseOrder();}
      else if(Strategy1PointsProfit() < (Strategy1SLValue*(-1))){Strategy1Step=0;Strategy1TradeType=0;Strategy1CloseOrder();}
      else if(OrdersTotal()==0){Strategy1Step=0;Strategy1TradeType=0;}


   
     
   } 
   //Sell
   if(Strategy1TradeType==2)
   {
     
     if(Strategy1PointsProfit() > Strategy1TPValue){Strategy1Step=0;Strategy1TradeType=0;Strategy1CloseOrder();}
     else if(Strategy1PointsProfit() < (Strategy1SLValue*(-1))){Strategy1Step=0;Strategy1TradeType=0;Strategy1CloseOrder();} 
     else if(OrdersTotal()==0){Strategy1Step=0;Strategy1TradeType=0;}

     
   } 
}
//Strategy 1 Step 4 End ********************************************************************************


void Strategy1CloseOrder()
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
  
  
  double Strategy1PointsProfit()
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