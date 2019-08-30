   double PendingOrderRange = 35;
   double PendingOrderTP =1000;
   double PendingOrderSL =50;
   double PendingOrderTrailSL =50;
   int ActiveOrderType =0;
   double LootSizes = (AccountBalance()/5000);
   
void StartTradingSequence(int &Step,datetime TimeLeftNews, string CurrentTradeSymbol)
{
  

   switch(Step)
   {  
   
      case 0: TradeCase0(TimeLeftNews,Step);break;//Wait for news to be 10 sec before news
      case 1: TradeCase1(TimeLeftNews,Step,CurrentTradeSymbol);break;//Open Pending Orders
      case 2: TradeCase2(TimeLeftNews,Step);break;//Adjust Pending Orders untill 10 sec left
      case 3: TradeCase3(TimeLeftNews,Step);break;//Cancell not triggered order
      case 4: TradeCase4(TimeLeftNews,Step);break;//Wait untill TP/SL hit and no orders opened

   }
}

void TradeCase0(datetime TimeLeftNews,int &Step)
{

 if(TimeLeftNews<10)
   {

      Step=1;
   }
}



void TradeCase1(datetime TimeLeftNews,int &Step, string CurrentTradeSymbol)
{
  
      
         int ticketBUY=OrderSend(CurrentTradeSymbol,OP_BUYSTOP,LootSizes,MarketInfo(CurrentTradeSymbol, MODE_BID)+(PendingOrderRange*MarketInfo(CurrentTradeSymbol,MODE_POINT)),0,MarketInfo(CurrentTradeSymbol, MODE_BID)-(PendingOrderSL*MarketInfo(CurrentTradeSymbol,MODE_POINT)),MarketInfo(CurrentTradeSymbol, MODE_ASK)+(PendingOrderTP*MarketInfo(CurrentTradeSymbol,MODE_POINT)),"MyNewsEA_BUY",255,3,CLR_NONE);
         int ticketSELL=OrderSend(CurrentTradeSymbol,OP_SELLSTOP,LootSizes,MarketInfo(CurrentTradeSymbol, MODE_ASK)-(PendingOrderRange*MarketInfo(CurrentTradeSymbol,MODE_POINT)),0,MarketInfo(CurrentTradeSymbol, MODE_ASK)+(PendingOrderSL*MarketInfo(CurrentTradeSymbol,MODE_POINT)),MarketInfo(CurrentTradeSymbol, MODE_BID)-(PendingOrderTP*MarketInfo(CurrentTradeSymbol,MODE_POINT)),"MyNewsEA_SELL",255,3,CLR_NONE);
      
      Step=2;
   
}


void TradeCase2(datetime TimeLeftNews,int &Step){
   if(CountOpenedOrders()>0){ClosePendingOrder();Step=3;modifyOrdersPending();}
   if(TimeLeftNews<(-400)){ClosePendingOrder();Step=0;CloseAllOrder();}
  
   }


void TradeCase3(datetime TimeLeftNews,int &Step){modifyOrdersPending();if(CountOpenedOrders()==0){Step=9;}}

void TradeCase4(datetime TimeLeftNews,int &Step)
{
   if(TimeLeftNews<(-1200))
   {
      //Reload news
      xmlRead();
      UpdateForexFactory();
      CloseAllOrder();
      xmlRead();
      UpdateForexFactory();
      ExtractNewsData(); 
      Step=0;
   }
   else
   {
      Step=1;
   
   }

}


 //Count Opened Orders
int CountOpenedOrders()
 {
   int CountTrades =0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(StringFind(OrderComment(),"MyNewsEA_")>-1)
           {
            if(OrderType()==OP_BUY){CountTrades=CountTrades+1;}
            if(OrderType()==OP_SELL){CountTrades=CountTrades+1;}
           }
     }
     return CountTrades;
}

int CountPendingOrders()
 {
   int CountTrades =0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(StringFind(OrderComment(),"MyNewsEA_")>-1)
           {
            if(OrderType()==OP_BUYSTOP){CountTrades=CountTrades+1;}
            if(OrderType()==OP_SELLSTOP){CountTrades=CountTrades+1;}
           }
     }
     return CountTrades;
}


//Close untriggered Pending Order
void ClosePendingOrder()
  {
//Close Long Order
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(StringFind(OrderComment(),"MyNewsEA_")>-1)
           {
            if(OrderType()==OP_BUYSTOP)
              {
               double CloseBuy=OrderDelete(OrderTicket());
              }
            if(OrderType()==OP_SELLSTOP)
              {

               double CloseSell=OrderDelete(OrderTicket());
            
              }
           }
     }
  }
 
   void CloseAllOrder()
  {
//Close Long Order
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(StringFind(OrderComment(),"MyNewsEA_")>-1)
           {
           
               double CloseAll=OrderDelete(OrderTicket());
           
              }
           
           
     }
  }
 


void modifyOrdersPending()
{
            double TP;
            double Price;
            int    Ticket;   
            bool Ans;

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(StringFind(OrderComment(),"MyNewsEA_")>-1)
           {
            if(OrderType()==OP_BUY){
               TP    =OrderOpenPrice()+(PendingOrderTP*MarketInfo(OrderSymbol(),MODE_POINT));  // TP of the selected order
               Price =OrderOpenPrice();     // Price of the selected order
               Ticket=OrderTicket();
               
               if((MarketInfo(OrderSymbol(), MODE_BID)- OrderStopLoss())/MarketInfo(OrderSymbol(),MODE_POINT)>PendingOrderTrailSL)
               {
                  Ans=OrderModify(Ticket,Price,MarketInfo(OrderSymbol(), MODE_BID)-(PendingOrderTrailSL*MarketInfo(OrderSymbol(),MODE_POINT)),TP,0);//Modify it!
               }
               else
               {
                  Ans=OrderModify(Ticket,Price,OrderStopLoss(),TP,0);//Modify it!
               }
                
            
            }
            if(OrderType()==OP_SELL){
            
            TP    =OrderOpenPrice()-(PendingOrderTP*MarketInfo(OrderSymbol(),MODE_POINT));  // TP of the selected order
            Price =OrderOpenPrice();     // Price of the selected order
            Ticket=OrderTicket();    
            
            
             if((OrderStopLoss()-MarketInfo(OrderSymbol(), MODE_ASK) )/MarketInfo(OrderSymbol(),MODE_POINT)>PendingOrderTrailSL)
               {
                  Ans=OrderModify(Ticket,Price,MarketInfo(OrderSymbol(), MODE_ASK)+(PendingOrderTrailSL*MarketInfo(OrderSymbol(),MODE_POINT)),TP,0);//Modify it!
               }
               else
               {
                  Ans=OrderModify(Ticket,Price,OrderStopLoss(),TP,0);//Modify it!
               }
               
               
            }
           }
     }


}