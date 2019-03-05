//+------------------------------------------------------------------+
//|                                 ForexStrategyMasterStrategy1.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""



void Strategy4CheckStatus(
                          int &Strategy4Step, 
                          int &Strategy4TradeType, 
                          double Strategy4EMA3Period1H, 
                          double Strategy4EMA5Period1H, 
                          double Strategy4EMA15Period1H, 
                          double Strategy4EMA45Period1H,
                          int Strategy4GHL1H,
                          int Strategy4QTI1H,
                          double Strategy4EMA3Period15M, 
                          double Strategy4EMA5Period15M, 
                          double Strategy4EMA15Period15M, 
                          double Strategy4EMA45Period15M,
                          int Strategy4GHL15M,
                          int Strategy4QTI15M,
                          long Strategy4TPValue,
                          long Strategy4SLValue,
                          int Strategy4EMAFullTrend
                          )
{

   switch(Strategy4Step)
   {
      case 0: Strategy4Step0(Strategy4Step, 
                          Strategy4TradeType, 
                          Strategy4EMA3Period1H, 
                          Strategy4EMA5Period1H, 
                          Strategy4EMA15Period1H, 
                          Strategy4EMA45Period1H,
                          Strategy4GHL1H,
                          Strategy4QTI1H,
                          Strategy4EMA3Period15M, 
                          Strategy4EMA5Period15M, 
                          Strategy4EMA15Period15M, 
                          Strategy4EMA45Period15M,
                          Strategy4GHL15M,
                          Strategy4QTI15M,
                          Strategy4TPValue,
                          Strategy4SLValue,
                          Strategy4EMAFullTrend);break;
      
      case 1: Strategy4Step1(Strategy4Step, 
                          Strategy4TradeType, 
                          Strategy4EMA3Period1H, 
                          Strategy4EMA5Period1H, 
                          Strategy4EMA15Period1H, 
                          Strategy4EMA45Period1H,
                          Strategy4GHL1H,
                          Strategy4QTI1H,
                          Strategy4EMA3Period15M, 
                          Strategy4EMA5Period15M, 
                          Strategy4EMA15Period15M, 
                          Strategy4EMA45Period15M,
                          Strategy4GHL15M,
                          Strategy4QTI15M,
                          Strategy4TPValue,
                          Strategy4SLValue,
                          Strategy4EMAFullTrend);break;
      
      case 2: Strategy4Step2(Strategy4Step, 
                          Strategy4TradeType, 
                          Strategy4EMA3Period1H, 
                          Strategy4EMA5Period1H, 
                          Strategy4EMA15Period1H, 
                          Strategy4EMA45Period1H,
                          Strategy4GHL1H,
                          Strategy4QTI1H,
                          Strategy4EMA3Period15M, 
                          Strategy4EMA5Period15M, 
                          Strategy4EMA15Period15M, 
                          Strategy4EMA45Period15M,
                          Strategy4GHL15M,
                          Strategy4QTI15M,
                          Strategy4TPValue,
                          Strategy4SLValue,
                          Strategy4EMAFullTrend);break;
                          
      case 3: Strategy4Step3(Strategy4Step, 
                          Strategy4TradeType, 
                          Strategy4EMA3Period1H, 
                          Strategy4EMA5Period1H, 
                          Strategy4EMA15Period1H, 
                          Strategy4EMA45Period1H,
                          Strategy4GHL1H,
                          Strategy4QTI1H,
                          Strategy4EMA3Period15M, 
                          Strategy4EMA5Period15M, 
                          Strategy4EMA15Period15M, 
                          Strategy4EMA45Period15M,
                          Strategy4GHL15M,
                          Strategy4QTI15M,
                          Strategy4TPValue,
                          Strategy4SLValue,
                          Strategy4EMAFullTrend);break;
                          
     case 4: Strategy4Step4(Strategy4Step, 
                          Strategy4TradeType, 
                          Strategy4EMA3Period1H, 
                          Strategy4EMA5Period1H, 
                          Strategy4EMA15Period1H, 
                          Strategy4EMA45Period1H,
                          Strategy4GHL1H,
                          Strategy4QTI1H,
                          Strategy4EMA3Period15M, 
                          Strategy4EMA5Period15M, 
                          Strategy4EMA15Period15M, 
                          Strategy4EMA45Period15M,
                          Strategy4GHL15M,
                          Strategy4QTI15M,
                          Strategy4TPValue,
                          Strategy4SLValue,
                          Strategy4EMAFullTrend);break;  
                    
     
   
   }
}
//********************************************************************************************************
//******************************************STEPS FUNCTIONS***********************************************
//********************************************************************************************************
//Strategy 1 Step 0 Start ********************************************************************************
void Strategy4Step0(int &Strategy4Step, 
                          int &Strategy4TradeType, 
                          double Strategy4EMA3Period1H, 
                          double Strategy4EMA5Period1H, 
                          double Strategy4EMA15Period1H, 
                          double Strategy4EMA45Period1H,
                          int Strategy4GHL1H,
                          int Strategy4QTI1H,
                          double Strategy4EMA3Period15M, 
                          double Strategy4EMA5Period15M, 
                          double Strategy4EMA15Period15M, 
                          double Strategy4EMA45Period15M,
                          int Strategy4GHL15M,
                          int Strategy4QTI15M,
                          long Strategy4TPValue,
                          long Strategy4SLValue,
                          long Strategy4EMAFullTrend)
{
 
   //Buy criteria
   if(Strategy4EMA15Period1H > Strategy4EMA45Period1H  && Strategy4QTI1H==1 && Strategy4GHL1H==1){Strategy4Step=1;Strategy4TradeType=1;}
   //Sell criteria
   else if(Strategy4EMA15Period1H < Strategy4EMA45Period1H && Strategy4QTI1H==2 && Strategy4GHL1H==2){Strategy4Step=1;Strategy4TradeType=2;}
   else {Strategy4Step=0;Strategy4TradeType=0;}

 
}
//Strategy 1 Step 0 End ********************************************************************************


//Strategy 1 Step 1 Start ********************************************************************************
void Strategy4Step1(int &Strategy4Step, 
                          int &Strategy4TradeType, 
                          double Strategy4EMA3Period1H, 
                          double Strategy4EMA5Period1H, 
                          double Strategy4EMA15Period1H, 
                          double Strategy4EMA45Period1H,
                          int Strategy4GHL1H,
                          int Strategy4QTI1H,
                          double Strategy4EMA3Period15M, 
                          double Strategy4EMA5Period15M, 
                          double Strategy4EMA15Period15M, 
                          double Strategy4EMA45Period15M,
                          int Strategy4GHL15M,
                          int Strategy4QTI15M,
                          long Strategy4TPValue,
                          long Strategy4SLValue,
                          long Strategy4EMAFullTrend)
{
   //Buy
   if(Strategy4TradeType==1)
   {
      //check if setup voided
      if(Strategy4EMA15Period1H < Strategy4EMA45Period1H ){Strategy4Step=0;Strategy4TradeType=0;}
      else if(Strategy4GHL1H != 1){Strategy4Step=2;Strategy4TradeType=1;}
      else if (Strategy4QTI1H != 1){Strategy4Step=2;Strategy4TradeType=1;}
      
   }
   //Sell
   if(Strategy4TradeType==2)
   {
      //check if setup voided
      if(Strategy4EMA15Period1H > Strategy4EMA45Period1H ){Strategy4Step=0;Strategy4TradeType=0;}
      else if(Strategy4GHL1H != 2){Strategy4Step=2;Strategy4TradeType=2;}
      else if (Strategy4QTI1H != 2){Strategy4Step=2;Strategy4TradeType=2;}
      
   }   
}
//Strategy 1 Step 1 End ********************************************************************************


//Strategy 1 Step 2 Start ********************************************************************************
void Strategy4Step2(int &Strategy4Step, 
                          int &Strategy4TradeType, 
                          double Strategy4EMA3Period1H, 
                          double Strategy4EMA5Period1H, 
                          double Strategy4EMA15Period1H, 
                          double Strategy4EMA45Period1H,
                          int Strategy4GHL1H,
                          int Strategy4QTI1H,
                          double Strategy4EMA3Period15M, 
                          double Strategy4EMA5Period15M, 
                          double Strategy4EMA15Period15M, 
                          double Strategy4EMA45Period15M,
                          int Strategy4GHL15M,
                          int Strategy4QTI15M,
                          long Strategy4TPValue,
                          long Strategy4SLValue,
                          long Strategy4EMAFullTrend)
{
   //Buy
   if(Strategy4TradeType==1)
   {
      //check if setup voided
      if(Strategy4EMA15Period1H < Strategy4EMA45Period1H ){Strategy4Step=0;Strategy4TradeType=0;}
      else if(Strategy4GHL1H == 1 && Strategy4QTI1H == 1){Strategy4Step=3;Strategy4TradeType=1;}
      else if(OrdersTotal()==0){Strategy4Step=0;Strategy4TradeType=0;}
      
      
   }
   //Sell
   if(Strategy4TradeType==2)
   {
      //check if setup voided
      if(Strategy4EMA15Period1H > Strategy4EMA45Period1H ){Strategy4Step=0;Strategy4TradeType=0;}
      else if(Strategy4GHL1H == 2 && Strategy4QTI1H == 2){Strategy4Step=3;Strategy4TradeType=2;}
      else if(OrdersTotal()==0){Strategy4Step=0;Strategy4TradeType=0;}

      
   }   
  
}
//Strategy 1 Step 2 End ********************************************************************************


//Strategy 1 Step 3 Start ********************************************************************************
void Strategy4Step3(int &Strategy4Step, 
                          int &Strategy4TradeType, 
                          double Strategy4EMA3Period1H, 
                          double Strategy4EMA5Period1H, 
                          double Strategy4EMA15Period1H, 
                          double Strategy4EMA45Period1H,
                          int Strategy4GHL1H,
                          int Strategy4QTI1H,
                          double Strategy4EMA3Period15M, 
                          double Strategy4EMA5Period15M, 
                          double Strategy4EMA15Period15M, 
                          double Strategy4EMA45Period15M,
                          int Strategy4GHL15M,
                          int Strategy4QTI15M,
                          long Strategy4TPValue,
                          long Strategy4SLValue,
                          long Strategy4EMAFullTrend)
{
     //Buy
   if(Strategy4TradeType==1)
   {
   
      int BuyTicket=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,clrGreen);
      Strategy4Step = 4;
   
     
   } 
   //Sell
   if(Strategy4TradeType==2)
   {
     
     int SellTicket=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,clrRed);
     Strategy4Step = 4;
     
   } 
  
  
  
}
//Strategy 1 Step 3 End ********************************************************************************


//Strategy 1 Step 4 Start ********************************************************************************
void Strategy4Step4(int &Strategy4Step, 
                          int &Strategy4TradeType, 
                          double Strategy4EMA3Period1H, 
                          double Strategy4EMA5Period1H, 
                          double Strategy4EMA15Period1H, 
                          double Strategy4EMA45Period1H,
                          int Strategy4GHL1H,
                          int Strategy4QTI1H,
                          double Strategy4EMA3Period15M, 
                          double Strategy4EMA5Period15M, 
                          double Strategy4EMA15Period15M, 
                          double Strategy4EMA45Period15M,
                          int Strategy4GHL15M,
                          int Strategy4QTI15M,
                          long Strategy4TPValue,
                          long Strategy4SLValue,
                          long Strategy4EMAFullTrend)
{
     //Buy
   if(Strategy4TradeType==1)
   {
   
      if(Strategy4PointsProfit() > Strategy4TPValue){Strategy4Step=0;Strategy4TradeType=0;Strategy4CloseOrder();}
      else if(Strategy4PointsProfit() < (Strategy4SLValue*-1)){Strategy4Step=0;Strategy4TradeType=0;Strategy4CloseOrder();}
      else if(OrdersTotal()==0){Strategy4Step=0;Strategy4TradeType=0;}

   
     
   } 
   //Sell
   if(Strategy4TradeType==2)
   {
     
     if(Strategy4PointsProfit() > Strategy4TPValue){Strategy4Step=0;Strategy4TradeType=0;Strategy4CloseOrder();}
     else if(Strategy4PointsProfit() < (Strategy4SLValue*-1)){Strategy4Step=0;Strategy4TradeType=0;Strategy4CloseOrder();} 
     else if(OrdersTotal()==0){Strategy4Step=0;Strategy4TradeType=0;}

     
   } 
}
//Strategy 1 Step 4 End ********************************************************************************


void Strategy4CloseOrder()
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
  
  long Strategy4PointsProfit()
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