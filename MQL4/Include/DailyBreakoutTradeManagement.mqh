void TradeManagement (int &STEP, bool &OpenedTrade, double TradingLotSize, double DailyHigh, double DailyLow, long TP, long SL)
{
Comment (STEP);


   switch(STEP)
   {  
      //Price Between last candle high & low
      case 0: TradingStep0(STEP,OpenedTrade,TradingLotSize,DailyHigh,DailyLow); break;
      
      //Price outside last candle range
      case 1: TradingStep1(STEP,OpenedTrade,TradingLotSize,DailyHigh,DailyLow); break;
         
      //Open trade
      case 2: TradingStep2(STEP,OpenedTrade,TradingLotSize,DailyHigh,DailyLow,TP,SL); break;
      
      //Close Trade
      case 3: TradingStep3(STEP,OpenedTrade,TradingLotSize,DailyHigh,DailyLow); break;
      
   
   }

}

void TradingStep0(int &STEP, bool &OpenedTrade, double TradingLotSize, double DailyHigh, double DailyLow)
{
   if(Bid > DailyLow && Ask > DailyLow && Bid < DailyHigh && Ask < DailyHigh && OpenedTrade==false){STEP=1;}



}
void TradingStep1(int &STEP, bool &OpenedTrade, double TradingLotSize, double DailyHigh, double DailyLow)
{
   if(Bid > DailyHigh && Ask > DailyHigh && OpenedTrade==false)
   {
      STEP=2;
      //int BuyTicket=OrderSend(Symbol(),OP_BUY,TradingLotSize,Ask,3,NULL,NULL,NULL,1,0,clrGreen);
      int SellTicket=OrderSend(Symbol(),OP_SELL,TradingLotSize,Bid,3,NULL,NULL,NULL,1,0,clrRed);
      OpenedTrade=true;
   }
   else if(Bid < DailyLow && Ask < DailyLow && OpenedTrade==false)
   {
      STEP=2;
      //int SellTicket=OrderSend(Symbol(),OP_SELL,TradingLotSize,Bid,3,NULL,NULL,NULL,1,0,clrRed);
      int BuyTicket=OrderSend(Symbol(),OP_BUY,TradingLotSize,Ask,3,NULL,NULL,NULL,1,0,clrGreen);
      OpenedTrade=true;
      
   
   }
   

}
void TradingStep2(int &STEP, bool &OpenedTrade, double TradingLotSize, double DailyHigh, double DailyLow, long TP, long SL)
{
   if (PointsProfit(1) > TP){CloseOrder(1); STEP=0; OpenedTrade=false;}
   else if ( PointsProfit(1) < (SL* (-1)) ){CloseOrder(1); STEP=0; OpenedTrade=false;}


}
void TradingStep3(int &STEP, bool &OpenedTrade, double TradingLotSize, double DailyHigh, double DailyLow)
{



}

 long PointsProfit( int MagicNumberToCheck)
{
 long ProfitInPoints;
   for(int i=0; i<OrdersTotal(); i++)
   {  
      
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if (OrderSymbol()==Symbol()  && OrderMagicNumber()==MagicNumberToCheck){ProfitInPoints = OrderProfit();}
      
      
   
   }

   return ProfitInPoints;
}

void CloseOrder(int MagicNumberToCheck)
  {
//Close Long Order
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumberToCheck)
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