//+------------------------------------------------------------------+
//|                                 ForexStrategyMasterDashboard.mqh |
//|                                                  Michal Papinski |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Michal Papinski"
#property link      ""

void DrawDashboard()
{
   EditCreate("DashboardHeader",0,30,200,20,"Forex Strategy Master EA",clrSteelBlue,clrDimGray);
   
   EditCreate("TradingHeader",0,50,200,20,"Trading",clrLightSteelBlue,clrDimGray);

   
   EditCreate("StrategyTypeHeader",0,70,100,20,"Strategy Type",clrDeepSkyBlue,clrDimGray);
   EditCreate("StrategyStatusHeader",100,70,50,20,"Status",clrSilver,clrDimGray);
   EditCreate("StrategyTradesHeader",150,70,50,20,"Trades",clrSilver,clrDimGray);
   
   EditCreate("StrategyType1",0,90,100,20,"Strategy 1",clrDeepSkyBlue,clrDimGray);
   EditCreate("StartegyType1Status",100,90,50,20,"pending",clrSilver,clrDimGray);
   EditCreate("StartegyType1Trades",150,90,50,20,"0",clrSilver,clrDimGray);
   
   EditCreate("StrategyType2",0,110,100,20,"Strategy 2",clrDeepSkyBlue,clrDimGray);
   EditCreate("StartegyType2Status",100,110,50,20,"pending",clrSilver,clrDimGray);
   EditCreate("StartegyType2Trades",150,110,50,20,"0",clrSilver,clrDimGray);
   
   EditCreate("StrategyType3",0,130,100,20,"Strategy 3",clrDeepSkyBlue,clrDimGray);
   EditCreate("StartegyType3Status",100,130,50,20,"pending",clrSilver,clrDimGray);
   EditCreate("StartegyType3Trades",150,130,50,20,"0",clrSilver,clrDimGray);
   
   EditCreate("StrategyType4",0,150,100,20,"Strategy 4",clrDeepSkyBlue,clrDimGray);
   EditCreate("StartegyType4Status",100,150,50,20,"pending",clrSilver,clrDimGray);
   EditCreate("StartegyType4Trades",150,150,50,20,"0",clrSilver,clrDimGray);
  
   EditCreate("IndicatorValuesHeader",0,170,200,20,"Indicator Values",clrDeepSkyBlue,clrDimGray);

   EditCreate("TypeHeader",0,190,100,20,"Type",clrLightSteelBlue,clrDimGray);
   EditCreate("CurrentTimeFrame",100,190,50,20,"H1",clrLightSteelBlue,clrDimGray);
   EditCreate("LowerTimeFrame",150,190,50,20,"M15",clrLightSteelBlue,clrDimGray);
   
   EditCreate("QTI",0,210,100,20,"QTI",clrDeepSkyBlue,clrDimGray);
   EditCreate("QTICurrentTimeFrame",100,210,50,20,"current",clrSilver,clrDimGray);
   EditCreate("QTILowerTimeFrame",150,210,50,20,"lower",clrSilver,clrDimGray);
   
   EditCreate("GHL",0,230,100,20,"GHL",clrDeepSkyBlue,clrDimGray);
   EditCreate("GHLCurrentTimeFrame",100,230,50,20,"current",clrSilver,clrDimGray);
   EditCreate("GHLLowerTimeFrame",150,230,50,20,"lower",clrSilver,clrDimGray);
   
   EditCreate("EMALongTrend",0,250,100,20,"EMA Long Trend",clrDeepSkyBlue,clrDimGray);
   EditCreate("EMALongTrendValue",100,250,100,20,"current",clrSilver,clrDimGray);

   
   EditCreate("EMAShortTrend",0,270,100,20,"EMA Short Trend",clrDeepSkyBlue,clrDimGray);
   EditCreate("EMAShortTrendValue",100,270,100,20,"current",clrSilver,clrDimGray);
   
   EditCreate("EMAFullTrend",0,290,100,20,"EMA Full Trend",clrDeepSkyBlue,clrDimGray);
   EditCreate("EMAFullTrendValue",100,290,100,20,"current",clrSilver,clrDimGray);


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
  
  
  
void UpdateDashboard( int DashboardStrategy1Step, 
                          int DashboardStrategy1TradeType,  
                          int DashboardStrategy2Step, 
                          int DashboardStrategy2TradeType,  
                          int DashboardStrategy3Step, 
                          int DashboardStrategy3TradeType,  
                          int DashboardStrategy4Step, 
                          int DashboardStrategy4TradeType, 
                          double DashboardEMA3Period1H, 
                          double DashboardEMA5Period1H, 
                          double DashboardEMA15Period1H, 
                          double DashboardEMA45Period1H,
                          int DashboardGHL1H,
                          int DashboardQTI1H,
                          double DashboardEMA3Period15M, 
                          double DashboardEMA5Period15M, 
                          double DashboardEMA15Period15M, 
                          double DashboardEMA45Period15M,
                          int DashboardGHL15M,
                          int DashboardQTI15M,
                          int DashboardAllEMATrend)

{


ObjectSetString(0,"StartegyType1Status",OBJPROP_TEXT,IntegerToString(DashboardStrategy1Step));
ObjectSetString(0,"StartegyType1Trades",OBJPROP_TEXT,IntegerToString(DashboardStrategy1TradeType));
ObjectSetString(0,"StartegyType2Status",OBJPROP_TEXT,IntegerToString(DashboardStrategy2Step));
ObjectSetString(0,"StartegyType2Trades",OBJPROP_TEXT,IntegerToString(DashboardStrategy2TradeType));
ObjectSetString(0,"StartegyType3Status",OBJPROP_TEXT,IntegerToString(DashboardStrategy3Step));
ObjectSetString(0,"StartegyType3Trades",OBJPROP_TEXT,IntegerToString(DashboardStrategy3TradeType));
ObjectSetString(0,"StartegyType4Status",OBJPROP_TEXT,IntegerToString(DashboardStrategy4Step));
ObjectSetString(0,"StartegyType4Trades",OBJPROP_TEXT,IntegerToString(DashboardStrategy4TradeType));
ObjectSetString(0,"QTICurrentTimeFrame",OBJPROP_TEXT,IntegerToString(DashboardQTI1H));
ObjectSetString(0,"QTILowerTimeFrame",OBJPROP_TEXT,IntegerToString(DashboardQTI15M));
ObjectSetString(0,"GHLCurrentTimeFrame",OBJPROP_TEXT,IntegerToString(DashboardGHL1H));
ObjectSetString(0,"GHLLowerTimeFrame",OBJPROP_TEXT,IntegerToString(DashboardGHL15M));
ObjectSetString(0,"EMAFullTrendValue",OBJPROP_TEXT,IntegerToString(DashboardAllEMATrend));

}

