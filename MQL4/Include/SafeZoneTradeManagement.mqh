void TradeManagement(int &Step, int &TradeType, double &lastS1price, double &lastS2price, double &lastR1price, double &lastR2price, string &StartingDate ,double LotSize)
{
  string DateCheck =TimeToStr(TimeCurrent(),TIME_DATE);
      
       double R = iHigh(Symbol(),PERIOD_D1,1) - iLow(Symbol(),PERIOD_D1,1);//range
      double p = (iHigh(Symbol(),PERIOD_D1,1) + iLow(Symbol(),PERIOD_D1,1) + iClose(Symbol(),PERIOD_D1,1) )/3;// Standard Pivot
      double r2 = p + (R * 0.618);
      double s2 = p - (R * 0.618);
      double r1 = p + (R * 0.382);
      double s1 = p - (R * 0.382);
      
//  Comment(StartingDate + "  |||||| " + DateCheck + "     |||||     " + Step + "    " + PointsProfit() + "<<<<<<<<<<>>>>>>>>>>  "  );
   
   
   
   
   switch(Step)
   {
      case 0: Step0(Step,TradeType,lastS1price, lastS2price,lastR1price, lastR2price,StartingDate,DateCheck,LotSize);break;
      case 1: Step1(Step,TradeType,lastS1price, lastS2price,lastR1price, lastR2price,LotSize,StartingDate,DateCheck);break;
      case 2: Step2(Step,TradeType,lastS1price, lastS2price,lastR1price, lastR2price,LotSize,StartingDate,DateCheck);break;
      case 3: Step3(Step,TradeType,lastS1price, lastS2price,lastR1price, lastR2price,LotSize,StartingDate,DateCheck);break;
      case 4: Step4(Step,TradeType,lastS1price, lastS2price,lastR1price, lastR2price,LotSize,StartingDate,DateCheck);break;

   }

}

void Step0(int &Step, int &TradeType,double &lastS1price, double &lastS2price,double &lastR1price, double &lastR2price, string &StartingDate, string &DateCheck ,double LotSize)
{
   
    double R = iHigh(Symbol(),PERIOD_D1,1) - iLow(Symbol(),PERIOD_D1,1);//range
      double p = (iHigh(Symbol(),PERIOD_D1,1) + iLow(Symbol(),PERIOD_D1,1) + iClose(Symbol(),PERIOD_D1,1) )/3;// Standard Pivot
      double r2 = p + (R * 0.618);
      double s2 = p - (R * 0.618);
      double r1 = p + (R * 0.382);
      double s1 = p - (R * 0.382);

 


   if(StartingDate!=DateCheck)
   {
      
      
   if(Bid> r1 && 1==1 && CalculateEMA15(PERIOD_H1) > CalculateEMA45(PERIOD_H1))
   {
      int BuyTicket=OrderSend(Symbol(),OP_BUY, LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      Step=1;
      TradeType=1;
      lastS1price=s1;
      lastS2price=s2;
      lastR1price=r1;
      lastR2price=r2;
      StartingDate=DateCheck;
      
      
   
   
   }
   else if(Bid<s1 && 1==1 && CalculateEMA15(PERIOD_H1) < CalculateEMA45(PERIOD_H1))
   {
      int SellTicket=OrderSend(Symbol(),OP_SELL, LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      Step=1;
      TradeType=2;
      lastS1price=s1;
      lastS2price=s2;
      lastR1price=r1;
      lastR2price=r2;
      StartingDate=DateCheck;
      
      
   
   }
   else {CloseOrder(); Step=0;}
  
  }

}
void Step1(int &Step, int TradeType,double lastS1price, double lastS2price,double lastR1price, double lastR2price ,double LotSize, string &StartingDate, string &DateCheck)
{
   
        double R = iHigh(Symbol(),PERIOD_D1,1) - iLow(Symbol(),PERIOD_D1,1);//range
      double p = (iHigh(Symbol(),PERIOD_D1,1) + iLow(Symbol(),PERIOD_D1,1) + iClose(Symbol(),PERIOD_D1,1) )/3;// Standard Pivot
      double r2 = p + (R * 0.618);
      double s2 = p - (R * 0.618);
      double r1 = p + (R * 0.382);
      double s1 = p - (R * 0.382);

      

      
   if(TradeType==1 && Ask>r2)
   {
      CloseOrder();
      Step=0;
     
   }
   else if(TradeType==1 && Ask<s1)
   {
      Step=2;
 
   }

   else if(TradeType==2 && Ask<s2)
   {
      CloseOrder();
      Step=0;
      
   }

   else if(TradeType==2 && Ask>r1)
   {
      Step=2;

   }



}
void Step2(int &Step, int TradeType,double lastS1price, double lastS2price,double lastR1price, double lastR2price ,double LotSize, string &StartingDate, string &DateCheck)
{


   double R = iHigh(Symbol(),PERIOD_D1,1) - iLow(Symbol(),PERIOD_D1,1);//range
      double p = (iHigh(Symbol(),PERIOD_D1,1) + iLow(Symbol(),PERIOD_D1,1) + iClose(Symbol(),PERIOD_D1,1) )/3;// Standard Pivot
      double r2 = p + (R * 0.618);
      double s2 = p - (R * 0.618);
      double r1 = p + (R * 0.382);
      double s1 = p - (R * 0.382);

      if(StartingDate!=DateCheck){CloseOrder();Step=0;}

      
    else if(TradeType==1)
   {
    //  int SellTicketHedge1=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);
    //  int SellTicketHedge2=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);
   //   int SellTicketHedge3=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);


      
          int BuyTicketHedge1=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
    //  int BuyTicketHedge2=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);

   
   
   
      Step=3;
     
   }
   else if(TradeType==2)
   {
    //  int BuyTicketHedge1=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);
    //  int BuyTicketHedge2=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);
    //  int BuyTicketHedge3=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);
   
   
//   int SellTicketHedge1=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge2=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);

      
      
      Step=3;
 
   }


   
}
void Step3(int &Step, int TradeType,double lastS1price, double lastS2price,double lastR1price, double lastR2price ,double LotSize, string &StartingDate, string &DateCheck)
{

if(StartingDate!=DateCheck){CloseOrder();Step=0;}

else if(PointsProfit()>10)
   {
      CloseOrder();
      Step=0;
   }
else if(TradeType==1 && PointsProfit()<-2500)
   {
   
           int BuyTicketHedge1=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      int BuyTicketHedge2=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      int BuyTicketHedge3=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      int BuyTicketHedge4=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
    //  int BuyTicketHedge5=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);
   Step=4;
   }
else if(TradeType==2 && PointsProfit()<-2500)
   {
         int SellTicketHedge1=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge2=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge3=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge4=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
   //   int SellTicketHedge5=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);
    Step=4;
   }
   

}
void Step4(int &Step, int TradeType,double lastS1price, double lastS2price,double lastR1price, double lastR2price ,double LotSize, string &StartingDate, string &DateCheck)
   {  
   
   if(StartingDate!=DateCheck){CloseOrder();Step=0;}
  else if(PointsProfit()>10)
   {
      CloseOrder();
      Step=0;
   }
else if(TradeType==1 && PointsProfit()<-5000)
   {
   
           int BuyTicketHedge1=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      int BuyTicketHedge2=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      int BuyTicketHedge3=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
      int BuyTicketHedge4=OrderSend(Symbol(),OP_BUY,LotSize,Ask,3,NULL,NULL,NULL,0,0,Green);
    //  int BuyTicketHedge5=OrderSend(Symbol(),OP_BUY,1,Ask,3,NULL,NULL,NULL,0,0,Green);
   Step=4;
   }
else if(TradeType==2 && PointsProfit()<-5000)
   {
         int SellTicketHedge1=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge2=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge3=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
      int SellTicketHedge4=OrderSend(Symbol(),OP_SELL,LotSize,Bid,3,NULL,NULL,NULL,0,0,Red);
   //   int SellTicketHedge5=OrderSend(Symbol(),OP_SELL,1,Bid,3,NULL,NULL,NULL,0,0,Red);
    Step=4;
   }
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
  
  
    double PointsProfit()
{
int  ProfitInPoints;
   for(int i=0; i<OrdersTotal(); i++)
   {  
      
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
       ProfitInPoints = ProfitInPoints + OrderProfit();
      
   
   }
   
   return (ProfitInPoints);
}

void checkRangeToBig ()
{

    double R = iHigh(Symbol(),PERIOD_D1,1) - iLow(Symbol(),PERIOD_D1,1);//range
      double p = (iHigh(Symbol(),PERIOD_D1,1) + iLow(Symbol(),PERIOD_D1,1) + iClose(Symbol(),PERIOD_D1,1) )/3;// Standard Pivot
      double r2 = p + (R * 0.618);
      double s2 = p - (R * 0.618);
      double r1 = p + (R * 0.382);
      double s1 = p - (R * 0.382);
      
      if((r1-s1)>600)
      {
      
      CloseOrder();
      
      }


}


double CalculateEMA15 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 15,3, MODE_EMA, PRICE_CLOSE, 1),5);
}


double CalculateEMA45 (int TimeFrame)
{
  return NormalizeDouble(iMA (Symbol(), TimeFrame, 45,3, MODE_EMA, PRICE_CLOSE, 1),5);
}
//PERIOD_H1