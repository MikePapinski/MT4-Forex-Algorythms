void DrawPivots(string &StartingDate, long &DaysCounter)
{
datetime TodaysDate = TimeCurrent();



 string DateCheck =TimeToStr(TimeCurrent(),TIME_DATE);


   if(StartingDate!=DateCheck)
   {
      double R = iHigh(Symbol(),PERIOD_D1,1) - iLow(Symbol(),PERIOD_D1,1);//range
      double p = (iHigh(Symbol(),PERIOD_D1,1) + iLow(Symbol(),PERIOD_D1,1) + iClose(Symbol(),PERIOD_D1,1) )/3;// Standard Pivot
      double r3 = p + (R * 1.000);
      double r2 = p + (R * 0.618);
      double r1 = p + (R * 0.382);
      double s1 = p - (R * 0.382);
      double s2 = p - (R * 0.618);
      double s3 = p - (R * 1.000);
      double s4 = p - (R * 1.618);
      double r4 = p + (R * 1.618);
      double s5 = p - (R * 2.618);
      double r5 = p + (R * 2.618);
      double s6 = p - (R * 4.236);
      double r6 = p + (R * 4.236);
   
   
      //TrendCreate(iTime(Symbol(),PERIOD_D1,0),p,iTime(Symbol(),PERIOD_D1,0)+86399,p,DaysCounter + "test1",clrYellow);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),r3,iTime(Symbol(),PERIOD_D1,0)+86399,r3,DaysCounter + "test2",clrGreen);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),r2,iTime(Symbol(),PERIOD_D1,0)+86399,r2,DaysCounter + "test3",clrGreen);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),r1,iTime(Symbol(),PERIOD_D1,0)+86399,r1,DaysCounter + "test4",clrGreenYellow);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),s1,iTime(Symbol(),PERIOD_D1,0)+86399,s1,DaysCounter + "test5",clrDarkOrange);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),s2,iTime(Symbol(),PERIOD_D1,0)+86399,s2,DaysCounter + "test6",clrRed);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),s3,iTime(Symbol(),PERIOD_D1,0)+86399,s3,DaysCounter + "test7",clrRed);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),s4,iTime(Symbol(),PERIOD_D1,0)+86399,s4,DaysCounter + "test8",clrRed);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),s5,iTime(Symbol(),PERIOD_D1,0)+86399,s5,DaysCounter + "test9",clrRed);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),r4,iTime(Symbol(),PERIOD_D1,0)+86399,r4,DaysCounter + "test10",clrGreen);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),r5,iTime(Symbol(),PERIOD_D1,0)+86399,r5,DaysCounter + "test11",clrGreen);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),r6,iTime(Symbol(),PERIOD_D1,0)+86399,r6,DaysCounter + "test12",clrGreen);
      TrendCreate(iTime(Symbol(),PERIOD_D1,0),s6,iTime(Symbol(),PERIOD_D1,0)+86399,s6,DaysCounter + "test13",clrRed);
      
      DaysCounter=DaysCounter+1;
      StartingDate=DateCheck;
   }

}


//+------------------------------------------------------------------+
//| Create a trend line by the given coordinates                     |
//+------------------------------------------------------------------+
bool TrendCreate(
                   datetime              time1=0,           // first point time
                 double                price1=0,          // first point price
                 datetime              time2=0,           // second point time
                 double                price2=0,          // second point price


            
                  const string          name="TrendLine",  // line name
                  const color           clr=clrRed,        // line color
                  const long            chart_ID=0,        // chart's ID
                 
                 const int             sub_window=0,      // subwindow index
                
                 
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=5,           // line width
                 const bool            back=true,        // in the background
                 const bool            selection=false,    // highlight to move
                 const bool            ray_right=false,   // line's continuation to the right
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- create a trend line by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- enable (true) or disable (false) the mode of continuation of the line's display to the right
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
  
  
  //+------------------------------------------------------------------+
//| Check the values of trend line's anchor points and set default   |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
void ChangeTrendEmptyPoints(datetime &time1,double &price1,
                            datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, it is equal to the first point's one
   if(!price2)
      price2=price1;
  }