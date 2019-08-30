//+------------------------------------------------------------------+
//|                                       ArtificialIntelligence.mq4 |
//|                               Copyright © 2006, Yury V. Reshetov |
//|                                         http://reshetov.xnet.uz/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Yury V. Reshetov ICQ:282715499  http://reshetov.xnet.uz/"
#property link      "http://reshetov.xnet.uz/"

/*
   ECN compatibility by Andriy Moraru, www.earnfore.com, 2012
*/

//---- input parameters
extern int    x1 = 120;
extern int    x2 = 120;
extern int    x3 = 19;
extern int    x4 = 100;
// StopLoss level
extern double sl = 80;
extern double lots = 1;
extern int MagicNumber = 888;
extern bool ECN_Mode = false; // In ECN mode, SL and TP aren't applied on OrderSend() but are added later with OrderModify()

static int prevtime = 0;
double Poin;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
   //Checking for unconvetional Point digits number
   if (Point == 0.00001) Poin = 0.0001; //5 digits
   else if (Point == 0.001) Poin = 0.01; //3 digits
   else Poin = Point; //Normal
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  double SL = 0, ecnSL = 0;
 if (AccountFreeMargin() < (2*lots*1000)) return(0);
	
   if(Time[0] == prevtime) 
       return(0);
   prevtime = Time[0];
   int spread = 3;
//----
   if(IsTradeAllowed()) 
     {
       RefreshRates();
       spread = MarketInfo(Symbol(), MODE_SPREAD);
     } 
   else 
     {
       prevtime = Time[1];
       return(0);
     }
   int ticket = -1;
// check for opened position
   int total = OrdersTotal();   
//----
   for(int i = 0; i < total; i++) 
     {
       SL = 0; ecnSL = 0;
       OrderSelect(i, SELECT_BY_POS, MODE_TRADES); 
       // check for symbol & magic number
       if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
         {
           int prevticket = OrderTicket();
           // long position is opened
           if(OrderType() == OP_BUY) 
             {
               // check profit 
               if(Bid > (OrderStopLoss() + (sl * 2  + spread) * Poin)) 
                 {               
                   if(perceptron() < 0) 
                     { // reverse
                     if (!ECN_Mode) SL = Ask + sl * Poin;
                     else ecnSL = Ask + sl * Poin;
                       ticket = OrderSend(Symbol(), OP_SELL, lots * 2, Bid, 3, 
                                          SL, 0, "AI", MagicNumber, 0, Red); 
                       if ((ticket > 0) && (ECN_Mode))
                       {
                        OrderSelect(ticket,SELECT_BY_TICKET);
                        OrderModify(OrderTicket(), OrderOpenPrice(), ecnSL, OrderTakeProfit(), 0);
                       }
                       Sleep(30000);
                       //----
                       if(ticket < 0) 
                           prevtime = Time[1];
                       else 
                           OrderCloseBy(ticket, prevticket, Blue);   
                     } 
                   else 
                     { // trailing stop
                       if(!OrderModify(OrderTicket(), OrderOpenPrice(), Bid - sl * Poin, 
                          0, 0, Blue)) 
                         {
                           Sleep(30000);
                           prevtime = Time[1];
                         }
                     }
                 }  
               // short position is opened
             } 
           else 
             {
               // check profit 
               if(Ask < (OrderStopLoss() - (sl * 2 + spread) * Poin)) 
                 {
                   if(perceptron() > 0) 
                     { // reverse
                        if (!ECN_Mode) SL = Bid - sl * Poin;
                        else ecnSL = Bid - sl * Poin;
                       ticket = OrderSend(Symbol(), OP_BUY, lots * 2, Ask, 3, 
                                          SL, 0, "AI", MagicNumber, 0, Blue); 
                       if ((ticket > 0) && (ECN_Mode))
                       {
                        OrderSelect(ticket,SELECT_BY_TICKET);
                        OrderModify(OrderTicket(), OrderOpenPrice(), ecnSL, OrderTakeProfit(), 0);
                       }
                       Sleep(30000);
                       //----
                       if(ticket < 0) 
                           prevtime = Time[1];
                       else 
                           OrderCloseBy(ticket, prevticket, Blue);   
                     } 
                   else 
                     { // trailing stop
                       if(!OrderModify(OrderTicket(), OrderOpenPrice(), Ask + sl * Poin, 
                          0, 0, Blue)) 
                         {
                           Sleep(30000);
                           prevtime = Time[1];
                         }
                     }
                 }  
             }
           // exit
           return(0);
         }
     }
// check for long or short position possibility
   if(perceptron() > 0) 
     { //long
         SL = 0; ecnSL = 0;
         if (!ECN_Mode) SL = Bid - sl * Poin;
         else ecnSL = Bid - sl * Poin;                          
       ticket = OrderSend(Symbol(), OP_BUY, lots, Ask, 3, SL, 0, "AI", 
                          MagicNumber, 0, Blue);
       //----
       if(ticket < 0) 
         {
           Sleep(30000);
           prevtime = Time[1];
         }
         else if ((ticket > 0) && (ECN_Mode))
        {
         OrderSelect(ticket,SELECT_BY_TICKET);
         OrderModify(OrderTicket(), OrderOpenPrice(), ecnSL, OrderTakeProfit(), 0);
        }
     } 
   else 
     { // short
         SL = 0; ecnSL = 0;
         if (!ECN_Mode) SL = Ask + sl * Poin;
         else ecnSL = Ask + sl * Poin;                          
       ticket = OrderSend(Symbol(), OP_SELL, lots, Bid, 3, SL, 0, "AI", 
                          MagicNumber, 0, Red); 
       if(ticket < 0) 
         {
           Sleep(30000);
           prevtime = Time[1];
         }
        else if ((ticket > 0) && (ECN_Mode))
        {
         OrderSelect(ticket,SELECT_BY_TICKET);
         OrderModify(OrderTicket(), OrderOpenPrice(), ecnSL, OrderTakeProfit(), 0);
        }
     }
//--- exit
   return(0);
  }
//+------------------------------------------------------------------+
//| The PERCEPTRON - a perceiving and recognizing function           |
//+------------------------------------------------------------------+
double perceptron() 
  {
   double w1 = x1 - 100;
   double w2 = x2 - 100;
   double w3 = x3 - 100;
   double w4 = x4 - 100;
   double a1 = iAC(Symbol(), 0, 0);
   double a2 = iAC(Symbol(), 0, 7);
   double a3 = iAC(Symbol(), 0, 14);
   double a4 = iAC(Symbol(), 0, 21);
   return(w1 * a1 + w2 * a2 + w3 * a3 + w4 * a4);
  }
//+------------------------------------------------------------------+


