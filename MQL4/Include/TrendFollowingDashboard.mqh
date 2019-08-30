//+------------------------------------------------------------------+
//|                                    Trend Following Dashboard.mqh |
//|                                                             Mike |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Mike"
#property link      ""
#property strict


void DrawDashboard()
{




color MintColor = C'117,187,154';
color DarkBlueColor = C'51,63,80';
   

      
   EditCreate("BackgroundLine1",0,10,10000,5,"FX Divergence Trader",MintColor,MintColor);
   EditCreate("BackgroundLine2",10,0,5,10000,"FX Divergence Trader",DarkBlueColor,DarkBlueColor);


   EditCreate("LogoHeader",20,30,300,20,"FX Divergence Trader",MintColor,clrBlack);
   
   EditCreate("EAHeader",20,50,300,20,"Trend Following EA v.1",MintColor,clrBlack);
   
   EditCreate("ServerTimeHeader",20,70,100,20,"Server time:",DarkBlueColor,clrBlack,clrWhite);
   EditCreate("ServerTimeValue",120,70,200,20," ",clrWhite,clrBlack);
   
  // EditCreate("UserHeader",20,90,100,20,"User:",DarkBlueColor,clrBlack,clrWhite);
  // EditCreate("UserValue",120,90,200,20," ",clrWhite,clrBlack);
   
 //  EditCreate("LicenseHeader",20,110,100,20,"License expire:",DarkBlueColor,clrBlack,clrWhite);
 //  EditCreate("LicenseValue",120,110,200,20,"0",clrWhite,clrBlack);
   
   
   
   EditCreate("TradingHeader",20,150,400,20,"Trading",MintColor,clrBlack);
   
   EditCreate("StatusHeader",20,170,100,20,"Trend status:",DarkBlueColor,clrBlack,clrWhite);
   EditCreate("StatusNewsValue",120,170,300,20,"na",clrWhite,clrBlack);

   EditCreate("NewsCurrencyHeader",20,190,100,20,"Trading status:",DarkBlueColor,clrBlack,clrWhite);
   EditCreate("NewsCurrencyValue",120,190,300,20,"0",clrWhite,clrBlack);
   

   
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
                const color            clr=clrBlack,             // text color
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
               const long             chart_ID=0,               // chart's ID
                const int              sub_window=0,             // subwindow index
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=true,          // ability to edit
                
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
  
  
  
void UpdateDashboard(string TrendType, int TradingStep)

{

ObjectSetString(0,"ServerTimeValue",OBJPROP_TEXT,TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES));
ObjectSetString(0,"StatusNewsValue",OBJPROP_TEXT,TrendType);
ObjectSetString(0,"NewsCurrencyValue",OBJPROP_TEXT,TradingStep);
 ManageProfitOnChart();



}


void ManageProfitOnChart()
{
   if((AccountEquity()-AccountBalance())!=0)
   {     
      if(ObjectFind(0,"ProfitDollar")<0){EditCreate("ProfitDollar",210,20,200,60," ",clrRed,clrBlack,clrWhite,CORNER_RIGHT_UPPER);}
      if((AccountEquity()-AccountBalance())>0)
      {
         ObjectSetString(0,"ProfitDollar",OBJPROP_TEXT,NormalizeDouble((AccountEquity()-AccountBalance()),2) + " $");
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_BGCOLOR,clrGreen);
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_BORDER_COLOR,clrBlack);
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_FONTSIZE,30);
      }
      else
      {
         ObjectSetString(0,"ProfitDollar",OBJPROP_TEXT,NormalizeDouble((AccountEquity()-AccountBalance()),2) + " $");
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_COLOR,clrBlack);
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_BGCOLOR,clrRed);
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_BORDER_COLOR,clrBlack);
         ObjectSetInteger(0,"ProfitDollar",OBJPROP_FONTSIZE,30);
      }
   }
   else{if(ObjectFind(0,"ProfitDollar")==0){ObjectDelete(0,"ProfitDollar");}}
}






