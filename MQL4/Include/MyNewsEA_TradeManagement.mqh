double ActiveOpenPrice;
   int ActiveOrderType;
   double ActiveOrderSL;
   double ActiveOrderTP;
   double BreakEvenLevel;
   bool BreakEvenStatus;
   double BreakEvenExit;
   double LootSizes;
   bool multipletrades;
   int counter;
   double AddLotsize;
   double AllProfit;
   
   

void TradeManagement(int &StatusInfo, datetime &NewsDate,int BreakOutDistancePips,int TPPips,int SLPips,int SLTrail, int BreakEvenPips)
{


   switch(StatusInfo)
   {
      case 0: TradeCase0(StatusInfo,NewsDate); break;
      case 1: TradeCase1(StatusInfo,BreakOutDistancePips); break;
      case 2: TradeCase2(StatusInfo,NewsDate,BreakOutDistancePips); break;
      case 3: TradeCase3(StatusInfo,NewsDate); break;
      case 4: TradeCase4(StatusInfo,TPPips,SLPips,SLTrail,ActiveOpenPrice,ActiveOrderType,ActiveOrderSL,ActiveOrderTP,BreakEvenPips,BreakEvenLevel,BreakEvenStatus,BreakEvenExit); break;
      case 5: TradeCase5(StatusInfo,NewsDate,ActiveOrderType,ActiveOrderSL,ActiveOrderTP,BreakEvenLevel,BreakEvenStatus,BreakEvenExit,TPPips); break;
   }
}


//------------------------------------------------------
//Step 0: Waiting for 5 minutes before news
//------------------------------------------------------
void TradeCase0( int &StatusInfo, datetime NewsDate)
{
   counter = 0;
  
   LootSizes = (AccountBalance()/5000);
   AddLotsize = (AccountBalance()/5000);
   BreakEvenStatus=false;
   if(TimeToStr(TimeCurrent(),TIME_DATE)==TimeToStr(NewsDate,TIME_DATE) && TimeToStr(NewsDate-TimeCurrent(),TIME_MINUTES)< "00:05"){StatusInfo=1;}
}


//------------------------------------------------------
//Step 1: Create pending orders
//------------------------------------------------------
void TradeCase1( int &StatusInfo, int BreakOutDistancePips)
{
    counter = counter + 1;
   LootSizes=LootSizes + AddLotsize ;
  //LootSizes=LootSizes*2 ;
   int ticket1=OrderSend(Symbol(),OP_BUYSTOP,LootSizes,Ask+(BreakOutDistancePips*Point),0,0,0,"Buy stop",255,3,CLR_NONE);
   int ticket2=OrderSend(Symbol(),OP_SELLSTOP,LootSizes,Bid-(BreakOutDistancePips*Point),0,0,0,"Sell stop",255,3,CLR_NONE);
   StatusInfo=2;
}


//------------------------------------------------------
//Step 2: Adjust pending orders untill news time
//------------------------------------------------------
void TradeCase2( int &StatusInfo, datetime NewsDate,int BreakOutDistancePips)
{
   ModifyPendingOrder(BreakOutDistancePips);
   if(multipletrades==true){StatusInfo=3;}
   else if(TimeToStr(TimeCurrent(),TIME_DATE)==TimeToStr(NewsDate,TIME_DATE) && TimeToStr(NewsDate-TimeCurrent(),TIME_MINUTES) == "00:00" ){StatusInfo=3;}
}


//------------------------------------------------------
//Step 3: Delete reamin pending order when first order got triggered
//------------------------------------------------------
void TradeCase3( int &StatusInfo, datetime NewsDate)
{
   if(CountOpenedOrders()>0){ClosePendingOrder();StatusInfo=4;}
   else if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "00:06"){ClosePendingOrder();StatusInfo=8;}
}



//------------------------------------------------------
//Step 4: Get TP, SL, Values
//------------------------------------------------------
void TradeCase4(int &StatusInfo,int TPPips,int SLPips,int SLTrail, double &ActiveTradeOpenPrice, int &ActiveOrderType, double &ActiveOrderSL,double &ActiveOrderTP, double BreakEvenPips, double &BreakEvenLevel, bool &BreakEvenStatus,double &BreakEvenExit)
{
   //ActiveTradeOpenPrice=0;
   //ActiveOrderType=0;
   //ActiveOrderSL=0;
   //ActiveOrderTP=0;
   
   ActiveOrderParameters(ActiveTradeOpenPrice,ActiveOrderType);
   if(ActiveOrderType==1){ActiveOrderTP=ActiveTradeOpenPrice+(TPPips*Point); ActiveOrderSL=ActiveTradeOpenPrice-(SLPips*Point);BreakEvenLevel = ActiveTradeOpenPrice+(BreakEvenPips*Point) ; BreakEvenExit = ActiveTradeOpenPrice+(100*Point) ;}
   else if(ActiveOrderType==2){ActiveOrderTP=ActiveTradeOpenPrice-(TPPips*Point); ActiveOrderSL=ActiveTradeOpenPrice+(SLPips*Point);BreakEvenLevel = ActiveTradeOpenPrice-(BreakEvenPips*Point) ; BreakEvenExit = ActiveTradeOpenPrice-(100*Point) ;}
   StatusInfo=5;
  // Comment("ActiveOrderType:{"+ActiveOrderType+"} \\\\\ TP: {"+ActiveOrderTP+"} \\\\\ SL: {"+ActiveOrderSL+"}");
}




//------------------------------------------------------
//Step 5: Manage trade - Move SL, Close on TP, Close on TP
//------------------------------------------------------
void TradeCase5( int &StatusInfo, datetime NewsDate,int ActiveOrderType, double &ActiveOrderSL,double ActiveOrderTP,double &BreakEvenLevel, bool &BreakEvenStatus, double &BreakEvenExit, int TPPips)
{   
//if(PointsProfit()> (TPPips/10)){CloseAllOrders(1,NormalizeDouble((AccountEquity()-AccountBalance()),2));CloseAllOrders(2,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;}
   AllProfit=NormalizeDouble((AccountEquity()-AccountBalance()),2);
if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "00:05"){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "00:06"){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "00:07"){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "00:08"){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "01:20"){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
if(TimeToStr(TimeCurrent()-NewsDate,TIME_MINUTES) == "01:25"){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
    if(counter > 4){CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
   
   
   if(ActiveOrderType==1)
   {
     
      if(Bid < ActiveOrderSL && Ask < ActiveOrderSL){CurrPips=NormalizeDouble((AccountEquity()-AccountBalance()),2) ;CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=1;multipletrades=true;counter;PostTradeDB(AllProfit);}
      if(Bid > ActiveOrderTP && Ask > ActiveOrderTP){CurrPips=NormalizeDouble((AccountEquity()-AccountBalance()),2) ;CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
   //   if(counter == 1 && BreakEvenStatus == false && Bid > BreakEvenLevel && Ask > BreakEvenLevel){BreakEvenStatus=true;}
   //   if(BreakEvenStatus == true && Bid < BreakEvenExit ){CurrPips=NormalizeDouble((AccountEquity()-AccountBalance()),2) ;CloseAllOrders(1,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;}
      //if(Bid > (ActiveOrderTP-(200*Point)) && Ask > (ActiveOrderTP-(200*Point))){ActiveOrderSL=(ActiveOrderTP-(450*Point));}
   }
   else if(ActiveOrderType==2)
   {
      if(Bid > ActiveOrderSL && Ask > ActiveOrderSL){CurrPips=NormalizeDouble((AccountEquity()-AccountBalance()),2) ;CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=1;multipletrades=true;counter;PostTradeDB(AllProfit);}
      if(Bid < ActiveOrderTP && Ask < ActiveOrderTP){CurrPips=NormalizeDouble((AccountEquity()-AccountBalance()),2) ;CloseAllOrders(ActiveOrderType,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;PostTradeDB(AllProfit);}
   //  if(counter == 1 && BreakEvenStatus == false && Bid < BreakEvenLevel && Ask < BreakEvenLevel){BreakEvenStatus=true;}
   //   if(BreakEvenStatus == true && Ask > BreakEvenExit ){CurrPips=NormalizeDouble((AccountEquity()-AccountBalance()),2) ;CloseAllOrders(2,NormalizeDouble((AccountEquity()-AccountBalance()),2));StatusInfo=7;multipletrades=false;}

      //if(Bid > (ActiveOrderTP+(200*Point)) && Ask > (ActiveOrderTP+(200*Point))){ActiveOrderSL=(ActiveOrderTP+(450*Point));}
   }
   
   
   

}


//Modify Pending Order
void ModifyPendingOrder(int BreakOutDistancePips)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUYSTOP){double ModifyBuy=OrderModify(OrderTicket(),Ask+(BreakOutDistancePips*Point),0,0,0,clrBlue);}
            if(OrderType()==OP_SELLSTOP){double ModifySell=OrderModify(OrderTicket(),Bid-(BreakOutDistancePips*Point),0,0,0,clrRed);}
           }
     }
  }
  

  
//Close untriggered Pending Order
void ClosePendingOrder()
  {
//Close Long Order
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
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
  
  
  //Count Opened Orders
int CountOpenedOrders()
 {
   int CountTrades =0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY){CountTrades=CountTrades+1;}
            if(OrderType()==OP_SELL){CountTrades=CountTrades+1;}
           }
     }
     return CountTrades;
}

  //Get TP & SL & open price & order type data
int ActiveOrderParameters(double &OpenPriceData, int &OrderTypeData)
 {
   int CountTrades =0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY){OrderTypeData=1; OpenPriceData=OrderOpenPrice();}
            if(OrderType()==OP_SELL){OrderTypeData=2; OpenPriceData=OrderOpenPrice();}
           }
     }
     return CountTrades;
}
  
  
  
  
  long PointsProfit()
{
 long ProfitInPoints=0;
   for(int i=0; i<OrdersTotal(); i++)
   {  
      
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      ProfitInPoints = ProfitInPoints + OrderProfit();
      
   
   }
   
   return ProfitInPoints;
}  



void CloseAllOrders(int TradeType ,double P_and_L)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol())
           {
            if(OrderType()==OP_BUY){double CloseBuy=OrderClose(OrderTicket(),OrderLots(),Bid,0);P_L_TextCreate(P_and_L,TradeType);}
            if(OrderType()==OP_SELL){double CloseSell=OrderClose(OrderTicket(),OrderLots(),Ask,0);P_L_TextCreate(P_and_L,TradeType);}
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
  
  
  
