//+------------------------------------------------------------------+
//|                                 ForexStrategyMasterStrategy1.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""



void Strategy3CheckStatus(
                          int &Strategy3Step, 
                          int &Strategy3TradeType, 
                          double Strategy3EMA3Period1H, 
                          double Strategy3EMA5Period1H, 
                          double Strategy3EMA15Period1H, 
                          double Strategy3EMA45Period1H,
                          int Strategy3GHL1H,
                          int Strategy3QTI1H,
                          double Strategy3EMA3Period15M, 
                          double Strategy3EMA5Period15M, 
                          double Strategy3EMA15Period15M, 
                          double Strategy3EMA45Period15M,
                          int Strategy3GHL15M,
                          int Strategy3QTI15M,
                          long Strategy3TPValue,
                          long Strategy3SLValue,
                          int Strategy3EMAFullTrend
                          )
{

   switch(Strategy3Step)
   {
      case 0: Strategy3Step0(Strategy3Step, 
                          Strategy3TradeType, 
                          Strategy3EMA3Period1H, 
                          Strategy3EMA5Period1H, 
                          Strategy3EMA15Period1H, 
                          Strategy3EMA45Period1H,
                          Strategy3GHL1H,
                          Strategy3QTI1H,
                          Strategy3EMA3Period15M, 
                          Strategy3EMA5Period15M, 
                          Strategy3EMA15Period15M, 
                          Strategy3EMA45Period15M,
                          Strategy3GHL15M,
                          Strategy3QTI15M,
                          Strategy3TPValue,
                          Strategy3SLValue,
                          Strategy3EMAFullTrend);break;
      
      case 1: Strategy3Step1(Strategy3Step, 
                          Strategy3TradeType, 
                          Strategy3EMA3Period1H, 
                          Strategy3EMA5Period1H, 
                          Strategy3EMA15Period1H, 
                          Strategy3EMA45Period1H,
                          Strategy3GHL1H,
                          Strategy3QTI1H,
                          Strategy3EMA3Period15M, 
                          Strategy3EMA5Period15M, 
                          Strategy3EMA15Period15M, 
                          Strategy3EMA45Period15M,
                          Strategy3GHL15M,
                          Strategy3QTI15M,
                          Strategy3TPValue,
                          Strategy3SLValue,
                          Strategy3EMAFullTrend);break;
      
      case 2: Strategy3Step2(Strategy3Step, 
                          Strategy3TradeType, 
                          Strategy3EMA3Period1H, 
                          Strategy3EMA5Period1H, 
                          Strategy3EMA15Period1H, 
                          Strategy3EMA45Period1H,
                          Strategy3GHL1H,
                          Strategy3QTI1H,
                          Strategy3EMA3Period15M, 
                          Strategy3EMA5Period15M, 
                          Strategy3EMA15Period15M, 
                          Strategy3EMA45Period15M,
                          Strategy3GHL15M,
                          Strategy3QTI15M,
                          Strategy3TPValue,
                          Strategy3SLValue,
                          Strategy3EMAFullTrend);break;
                          
      case 3: Strategy3Step3(Strategy3Step, 
                          Strategy3TradeType, 
                          Strategy3EMA3Period1H, 
                          Strategy3EMA5Period1H, 
                          Strategy3EMA15Period1H, 
                          Strategy3EMA45Period1H,
                          Strategy3GHL1H,
                          Strategy3QTI1H,
                          Strategy3EMA3Period15M, 
                          Strategy3EMA5Period15M, 
                          Strategy3EMA15Period15M, 
                          Strategy3EMA45Period15M,
                          Strategy3GHL15M,
                          Strategy3QTI15M,
                          Strategy3TPValue,
                          Strategy3SLValue,
                          Strategy3EMAFullTrend);break;
                          
     case 4: Strategy3Step4(Strategy3Step, 
                          Strategy3TradeType, 
                          Strategy3EMA3Period1H, 
                          Strategy3EMA5Period1H, 
                          Strategy3EMA15Period1H, 
                          Strategy3EMA45Period1H,
                          Strategy3GHL1H,
                          Strategy3QTI1H,
                          Strategy3EMA3Period15M, 
                          Strategy3EMA5Period15M, 
                          Strategy3EMA15Period15M, 
                          Strategy3EMA45Period15M,
                          Strategy3GHL15M,
                          Strategy3QTI15M,
                          Strategy3TPValue,
                          Strategy3SLValue,
                          Strategy3EMAFullTrend);break;    
                    
     
   
   }
}
//********************************************************************************************************
//******************************************STEPS FUNCTIONS***********************************************
//********************************************************************************************************
//Strategy 1 Step 0 Start ********************************************************************************
void Strategy3Step0(int &Strategy3Step, 
                          int &Strategy3TradeType, 
                          double Strategy3EMA3Period1H, 
                          double Strategy3EMA5Period1H, 
                          double Strategy3EMA15Period1H, 
                          double Strategy3EMA45Period1H,
                          int Strategy3GHL1H,
                          int Strategy3QTI1H,
                          double Strategy3EMA3Period15M, 
                          double Strategy3EMA5Period15M, 
                          double Strategy3EMA15Period15M, 
                          double Strategy3EMA45Period15M,
                          int Strategy3GHL15M,
                          int Strategy3QTI15M,
                          long Strategy3TPValue,
                          long Strategy3SLValue,
                          long Strategy3EMAFullTrend)
{
 
   //Buy criteria
   if(Strategy3EMA15Period1H > Strategy3EMA45Period1H  && Strategy3QTI1H==1 && Strategy3GHL1H==1){Strategy3Step=1;Strategy3TradeType=1;}
   //Sell criteria
   else if(Strategy3EMA15Period1H < Strategy3EMA45Period1H && Strategy3QTI1H==2 && Strategy3GHL1H==2){Strategy3Step=1;Strategy3TradeType=2;}
   else {Strategy3Step=0;Strategy3TradeType=0;}

 
}
//Strategy 1 Step 0 End ********************************************************************************


//Strategy 1 Step 1 Start ********************************************************************************
void Strategy3Step1(int &Strategy3Step, 
                          int &Strategy3TradeType, 
                          double Strategy3EMA3Period1H, 
                          double Strategy3EMA5Period1H, 
                          double Strategy3EMA15Period1H, 
                          double Strategy3EMA45Period1H,
                          int Strategy3GHL1H,
                          int Strategy3QTI1H,
                          double Strategy3EMA3Period15M, 
                          double Strategy3EMA5Period15M, 
                          double Strategy3EMA15Period15M, 
                          double Strategy3EMA45Period15M,
                          int Strategy3GHL15M,
                          int Strategy3QTI15M,
                          long Strategy3TPValue,
                          long Strategy3SLValue,
                          long Strategy3EMAFullTrend)
{
   //Buy
   if(Strategy3TradeType==1)
   {
      //check if setup voided
      if(Strategy3EMA15Period1H < Strategy3EMA45Period1H ){Strategy3Step=0;Strategy3TradeType=0;}
      else if(Strategy3GHL1H != 1){Strategy3Step=2;Strategy3TradeType=1;}
      else if (Strategy3QTI1H != 1){Strategy3Step=2;Strategy3TradeType=1;}
      
   }
   //Sell
   if(Strategy3TradeType==2)
   {
      //check if setup voided
      if(Strategy3EMA15Period1H > Strategy3EMA45Period1H ){Strategy3Step=0;Strategy3TradeType=0;}
      else if(Strategy3GHL1H != 2){Strategy3Step=2;Strategy3TradeType=2;}
      else if (Strategy3QTI1H != 2){Strategy3Step=2;Strategy3TradeType=2;}
      
   }   
}
//Strategy 1 Step 1 End ********************************************************************************


//Strategy 1 Step 2 Start ********************************************************************************
void Strategy3Step2(int &Strategy3Step, 
                          int &Strategy3TradeType, 
                          double Strategy3EMA3Period1H, 
                          double Strategy3EMA5Period1H, 
                          double Strategy3EMA15Period1H, 
                          double Strategy3EMA45Period1H,
                          int Strategy3GHL1H,
                          int Strategy3QTI1H,
                          double Strategy3EMA3Period15M, 
                          double Strategy3EMA5Period15M, 
                          double Strategy3EMA15Period15M, 
                          double Strategy3EMA45Period15M,
                          int Strategy3GHL15M,
                          int Strategy3QTI15M,
                          long Strategy3TPValue,
                          long Strategy3SLValue,
                          long Strategy3EMAFullTrend)
{
   //Buy
   if(Strategy3TradeType==1)
   {
      //check if setup voided
      if(Strategy3EMA15Period1H < Strategy3EMA45Period1H ){Strategy3Step=0;Strategy3TradeType=0;}
      else if(Strategy3GHL1H == 1 && Strategy3QTI1H == 1){Strategy3Step=3;Strategy3TradeType=1;}
      else if(OrdersTotal()==0){Strategy3Step=0;Strategy3TradeType=0;}
      
      
   }
   //Sell
   if(Strategy3TradeType==2)
   {
      //check if setup voided
      if(Strategy3EMA15Period1H > Strategy3EMA45Period1H ){Strategy3Step=0;Strategy3TradeType=0;}
      else if(Strategy3GHL1H == 2 && Strategy3QTI1H == 2){Strategy3Step=3;Strategy3TradeType=2;}
      else if(OrdersTotal()==0){Strategy3Step=0;Strategy3TradeType=0;}

      
   }   
  
}
//Strategy 1 Step 2 End ********************************************************************************


//Strategy 1 Step 3 Start ********************************************************************************
void Strategy3Step3(int &Strategy3Step, 
                          int &Strategy3TradeType, 
                          double Strategy3EMA3Period1H, 
                          double Strategy3EMA5Period1H, 
                          double Strategy3EMA15Period1H, 
                          double Strategy3EMA45Period1H,
                          int Strategy3GHL1H,
                          int Strategy3QTI1H,
                          double Strategy3EMA3Period15M, 
                          double Strategy3EMA5Period15M, 
                          double Strategy3EMA15Period15M, 
                          double Strategy3EMA45Period15M,
                          int Strategy3GHL15M,
                          int Strategy3QTI15M,
                          long Strategy3TPValue,
                          long Strategy3SLValue,
                          long Strategy3EMAFullTrend)
{
     //Buy
   if(Strategy3TradeType==1)
   {
   
      int BuyTicket=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,clrGreen);
      Strategy3Step = 4;
   
     
   } 
   //Sell
   if(Strategy3TradeType==2)
   {
     
     int SellTicket=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,clrRed);
     Strategy3Step = 4;
     
   } 
  
  
  
}
//Strategy 1 Step 3 End ********************************************************************************


//Strategy 1 Step 4 Start ********************************************************************************
void Strategy3Step4(int &Strategy3Step, 
                          int &Strategy3TradeType, 
                          double Strategy3EMA3Period1H, 
                          double Strategy3EMA5Period1H, 
                          double Strategy3EMA15Period1H, 
                          double Strategy3EMA45Period1H,
                          int Strategy3GHL1H,
                          int Strategy3QTI1H,
                          double Strategy3EMA3Period15M, 
                          double Strategy3EMA5Period15M, 
                          double Strategy3EMA15Period15M, 
                          double Strategy3EMA45Period15M,
                          int Strategy3GHL15M,
                          int Strategy3QTI15M,
                          long Strategy3TPValue,
                          long Strategy3SLValue,
                          long Strategy3EMAFullTrend)
{
     //Buy
   if(Strategy3TradeType==1)
   {
   
      if(Strategy3PointsProfit() > Strategy3TPValue){Strategy3Step=0;Strategy3TradeType=0;Strategy3CloseOrder();}
      else if(Strategy3PointsProfit() < (Strategy3SLValue*-1)){Strategy3Step=0;Strategy3TradeType=0;Strategy3CloseOrder();}
      else if(OrdersTotal()==0){Strategy3Step=0;Strategy3TradeType=0;}

   
     
   } 
   //Sell
   if(Strategy3TradeType==2)
   {
     
     if(Strategy3PointsProfit() > Strategy3TPValue){Strategy3Step=0;Strategy3TradeType=0;Strategy3CloseOrder();}
     else if(Strategy3PointsProfit() < (Strategy3SLValue*-1)){Strategy3Step=0;Strategy3TradeType=0;Strategy3CloseOrder();} 
     else if(OrdersTotal()==0){Strategy3Step=0;Strategy3TradeType=0;}

     
   } 
}
//Strategy 1 Step 4 End ********************************************************************************


void Strategy3CloseOrder()
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
  
  long Strategy3PointsProfit()
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