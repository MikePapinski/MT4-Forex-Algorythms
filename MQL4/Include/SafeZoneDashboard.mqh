//+------------------------------------------------------------------+
//|                                 ForexStrategyMasterDashboard.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""

void DrawDashboard()
{
   EditCreate("DashboardHeader",0,30,200,20,"FX Divergence Trader",clrMediumSeaGreen,clrBlack);
   
   EditCreate("TradingHeader",0,50,200,20,"Safe Zone EA v.1",clrWhite,clrBlack);

   
   EditCreate("StrategyTypeHeader",0,70,100,20,"Date",clrRoyalBlue,clrBlack);
   EditCreate("StrategyStatusHeader",100,70,50,20,"Buy",clrMediumSeaGreen,clrBlack);
   EditCreate("StrategyTradesHeader",150,70,50,20,"Sell",clrMediumSeaGreen,clrBlack);
   
   EditCreate("StrategyType1",0,90,100,20,"Trades",clrMediumSeaGreen,clrBlack);
   EditCreate("StartegyType1Status",100,90,50,20,"0",clrWhite,clrBlack);
   EditCreate("StartegyType1Trades",150,90,50,20,"0",clrWhite,clrBlack);
   
   EditCreate("StrategyType11",0,110,100,20,"Profit",clrMediumSeaGreen,clrBlack);
   EditCreate("StartegyType1Status1",100,110,50,20,"0",clrWhite,clrBlack);
   EditCreate("StartegyType1Trades1",150,110,50,20,"0",clrWhite,clrBlack);



}
//+------------------------------------------------------------------+
//| Create Edit object                                               |
//+------------------------------------------------------------------+
bool EditCreate(  
               const string           name="test1",              // object name
               const int              x=0,                      // X coordinate
                const int              y=30,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
               const string           text="Text",                // Text
               const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrBlack,       // border color
               const long             chart_ID=0,               // chart's ID
                const int              sub_window=0,             // subwindow index
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=true,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
//--- create edit field
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create \"Edit\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set object coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set object size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the type of text alignment in the object
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
//--- enable (true) or cancel (false) read-only mode
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
//--- set the chart's corner, relative to which object coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
  
  
  
void UpdateDashboard( double DoubleDailyHigh, 
                          double DoubleDailyLow)

{


ObjectSetString(0,"StartegyType1Status",OBJPROP_TEXT,DoubleToString(DoubleDailyHigh));
ObjectSetString(0,"StartegyType1Trades",OBJPROP_TEXT,DoubleToString(DoubleDailyLow));


}

