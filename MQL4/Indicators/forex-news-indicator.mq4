//+--------------------------------------------------------------------------------+
//|ForexNews Market Clock indicator                    forex_news_market_clock.mq4 |
//|                                                                                |
//| Made by Tjipke de Vries   (deVries) at mql4.com                                |
//|       Indicator displays a News Calendar with a market clock.                  |
//|       news events "http://www.dailyfx.com/files/"                              |
//|                                                                                |
//| Some sources I have used                                                       |
//| This article Displaying a News Calendar written by Slobodov Gleb and to read at|
//| http://articles.mql4.com/523 shows a way how to get data displayed on the chart|
//| The file contains the description of writing a simple and convenient indicator |
//| displaying  in a working  area the main economic events from external Internet |
//| resources.                                                                     |
//|                                                                                |
//| Another source I have used for this indicator is the indicator SimpleMarketInfo|
//| here to find   http://codebase.mql4.com/7157  made by  born2trade  (2010.11.25)|
//| It shows upcoming news events 1 hour before and 30 minutes after event. It also|
//| shows active sessions etc. It gives a look to all news events.                 |
//| changes on this.  I did wanna have the possibillity to choose the kind of news |
//| I like to see, and when local time isn't brokertime there was not the correct  |
//| displaying vertical lines on the chart.                                        |
//|                                                                                |
//| Found the indicator Clockzv1_2 auto.mq4  (http://forum.mql4.com/14052#91898)   |
//| from "Jerome" This version made it possible for me to write down the coming DST|
//| times for the local markets also. ST/DST changes are unique to each timezone.  |
//| To know when a market is open we have to know the right localtime...           |
//| timezones   http://www.timeanddate.com/worldclock/                             |
//| markethours: http://www.2011.worldmarkethours.com/Forex/index1024.htm          | 
//| Auckland/Sydney/Tokyo/Hong Kong/Europe/London/New York                         |
//|                                                                                |
//| The clock will display the different times, the open markets and market holiday|
//| More info:  http://www.donnaforex.com/forum/index.php?topic=4339.0             |
//+--------------------------------------------------------------------------------+
#property  copyright "deVries"
#property  link      ""
#property indicator_chart_window 
#property indicator_buffers 0 

//----
#import "wininet.dll"
int InternetAttemptConnect (int x);
  int InternetOpenA(string sAgent, int lAccessType, 
                    string sProxyName = "", string sProxyBypass = "", 
                    int lFlags = 0);
  int InternetOpenUrlA(int hInternetSession, string sUrl, 
                       string sHeaders = "", int lHeadersLength = 0,
                       int lFlags = 0, int lContext = 0);
  int InternetReadFile(int hFile, int& sBuffer[], int lNumBytesToRead, 
                       int& lNumberOfBytesRead[]);
  int InternetCloseHandle(int hInet);
#import

#define COLUMN_DATE        0
#define COLUMN_TIME        1
#define COLUMN_TIMEZONE    2
#define COLUMN_CURRENCY    3
#define COLUMN_DESCRIPTION 4
#define COLUMN_IMPORTANCE  5
#define COLUMN_ACTUAL      6
#define COLUMN_FORECAST    7
#define COLUMN_PREVIOUS    8

#define COLUMN_DATE_DAY_STR    0
#define COLUMN_DATE_MONTH_STR  1
#define COLUMN_DATE_DAY_INT    2

int        time_zone_gmt     =2;//LOCAL TIMEZONE WILL BE CHANGED TO 
                                //YOUR PC-TIMEZONE AUTOMATICLY

//---- input parameters news
extern string news_parameters = "Make your selection";
extern color  session_upcoming_title_color = Purple;
extern color  session_closing_color = Red;
extern color  bar_closing_color = Green;
extern string if_show_currency_news_only = "Choose auto true";
extern bool   auto = true;
extern bool   show_low_news     = true;
extern bool   show_medium_news  = true;
extern bool   show_high_news    = true;
extern color  news_past_color   = Gray;            
extern color  news_high_color   = Red;         
extern color  news_medium_color = Orange;         
extern color  news_low_color    = Blue;     
extern string if_auto_false = "select news currencie(s)";
extern bool   show_eur = true;
extern bool   show_usd = true;
extern bool   show_jpy = true;
extern bool   show_gbp = true;
extern bool   show_chf = true;
extern bool   show_cad = true;
extern bool   show_aud = true;
extern bool   show_nzd = true;
extern bool   show_cny = true;
//verticale lines
extern bool   show_news_lines  = true; //verticale lines show moments of news
extern bool   show_line_text   = true; //news text by verticale lines
//---------------------------------------------------
//---- input parameters clock
int           Clockcorner=0;
extern string input_parameters = "for the clock";
extern int       godown=0;
extern int       goright=0;
//Colors clock
extern color     labelColor=DarkSlateGray;
extern color     clockColor=DarkSlateGray;
extern color     ClockMktOpenColor=Red;
extern color     ClockMktHolidayClr=PaleTurquoise;// Blue;
bool             show12HourTime=false; //YOU CAN CHANGE IT BUT I LIKE THIS MORE
extern bool      ShowSpreadChart=true;
extern bool      ShowBarTime=true;
extern bool      ShowLocal=true;
extern bool      ShowBroker=true;
extern bool      ShowGMT=true;
//FOUND THE TIMES WHEN THE MARKETS WERE OPEN AT
//World Financial Markets   http://www.2011.worldmarkethours.com/Forex/index1024.htm
extern bool      Show_NEW_ZEALAND=true;//Auckland GMT+12
extern bool      Show_AUSTRALIA=true;//Sydney GMT+12
extern bool      Show_JAPAN=true;//Tokyo GMT+9
extern bool      Show_HONG_KONG=true;//    GMT+8
extern bool      Show_EUROPE=true;//Frankfurt GMT+1
extern bool      Show_LONDON=true;//GMT+0
extern bool      Show_NEW_YORK=true;//GMT-5


string     news_url       = "http://www.dailyfx.com/files/";
int        update_interval =15;
int        show_min_before_news =60;

int spread;

datetime NZDHoliday =0;
datetime AUDHoliday =0;
datetime JPYHoliday =0;
datetime CNYHoliday =0;
datetime EURHoliday =0;
datetime GBPHoliday =0;
datetime USDHoliday =0;
datetime localTime; 

#import "kernel32.dll"

void GetLocalTime(int& TimeArray[]);
void GetSystemTime(int& TimeArray[]);
int  GetTimeZoneInformation(int& TZInfoArray[]);

//---- buffers
double ExtMapBuffer1[];
int LondonTZ = 0;
int TokyoTZ = 9;
int NewYorkTZ = -5;
int SydneyTZ = 11;
int BerlinTZ = 1;
int AucklandTZ = 13;
int HongKongTZ = 8;
datetime newyork,london,frankfurt,tokyo,sydney,auckland,hongkong,GMT;
// -----------------------------------------------------------------------------------------------------------------------------
int TotalNews = 0;
string News[1000][10];
datetime lastUpdate = 0;
int NextNewsLine = 0;
int LastAlert = 0;

// -----------------------------------------------------------------------------------------------------------------------------
int init() 
{
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer1);
   int top = godown+20;
   int left2 = 70+goright;
   int left =left2;
   if (show12HourTime) left = left2-20;
   if (ShowSpreadChart)
   {
      ObjectMakeLabel("Spread Monitor1", left-45, top);
      ObjectMakeLabel("Spread Monitor2", left2+25, top);
      top += 15;
   }      
   if (ShowBarTime)
   {
      ObjectMakeLabel("barl", left2, top);
      ObjectMakeLabel("bart", left-45, top);
      top += 15;
   }     
   top += 5;
   if (ShowLocal) 
   {
      ObjectMakeLabel("locl", left2, top);
      ObjectMakeLabel("loct", left-45, top);
      top += 15;
   }
   if (ShowBroker)
   {
      ObjectMakeLabel("brol", left2, top);
      ObjectMakeLabel("brot", left-45, top);
      top += 15;
   }
   if (ShowGMT)
   {       
      ObjectMakeLabel("gmtl", left2, top);
      ObjectMakeLabel("gmtt", left-45, top);
      top += 15;
   }
   top += 5;
   if (Show_NEW_ZEALAND)
   {
      ObjectMakeLabel("NZDl", left2, top);
      ObjectMakeLabel("NZDt", left-45, top);
      top += 15;      
   }
   if (Show_AUSTRALIA)
   {
      ObjectMakeLabel("sydl", left2, top);
      ObjectMakeLabel("sydt", left-45, top);
      top += 15;      
   }
   if (Show_JAPAN)
   {
      ObjectMakeLabel("tokl", left2, top);
      ObjectMakeLabel("tokt", left-45, top);
      top += 15;      
   }
   if (Show_HONG_KONG)
   {
      ObjectMakeLabel("HKl", left2, top);
      ObjectMakeLabel("HKt", left-45, top);
      top += 15;      
   }            
   if (Show_EUROPE)
   {
      ObjectMakeLabel("berl", left2, top);
      ObjectMakeLabel("bert", left-45, top);
      top += 15;      
   }   
   if (Show_LONDON)
   {
      ObjectMakeLabel("lonl", left2, top);
      ObjectMakeLabel("lont", left-45, top);
      top += 15;      
   }
   if (Show_NEW_YORK)
   {
      ObjectMakeLabel("nyl", left2, top);
      ObjectMakeLabel("nyt", left-45, top);
      top += 15;      
   }

   CreateInfoObjects(); 
   return(0); 
} 

// -----------------------------------------------------------------------------------------------------------------------------
int deinit() 
{ 
//----
   ObjectDelete("locl");
   ObjectDelete("loct");
   ObjectDelete("nyl");
   ObjectDelete("nyt");
   ObjectDelete("gmtl");
   ObjectDelete("gmtt");
   ObjectDelete("berl");
   ObjectDelete("bert");
   ObjectDelete("NZDl");
   ObjectDelete("NZDt");   
   ObjectDelete("lonl");
   ObjectDelete("lont");
   ObjectDelete("tokl");
   ObjectDelete("tokt");
   ObjectDelete("HKl");
   ObjectDelete("HKt");   
   ObjectDelete("sydl");
   ObjectDelete("sydt");   
   ObjectDelete("brol");
   ObjectDelete("brot");
   ObjectDelete("barl");
   ObjectDelete("bart");
   ObjectDelete("Spread Monitor1");
   ObjectDelete("Spread Monitor2");
   
   DeleteNewsObjects();
   DeleteSessionInfoObjects(); 
//----
   DisplaySessionInfo();

   return(0); 
} 

// -----------------------------------------------------------------------------------------------------------------------------
int start()

{
  if ( !IsDllsAllowed() ) {
      Alert( "Clock V1_2: DLLs are disabled.  To enable tick the checkbox in the Common Tab of indicator" );
      return;
     }
   int    counted_bars=IndicatorCounted();
//----
      
   int    TimeArray[4];
   int    TZInfoArray[43];
   int    nYear,nMonth,nDay,nHour,nMin,nSec,nMilliSec;
   string sMilliSec;
   
   GetLocalTime(TimeArray);
//---- parse date and time from array
   nYear=TimeArray[0]&0x0000FFFF;
   nMonth=TimeArray[0]>>16;
   nDay=TimeArray[1]>>16;
   nHour=TimeArray[2]&0x0000FFFF;
   nMin=TimeArray[2]>>16;
   nSec=TimeArray[3]&0x0000FFFF;
   nMilliSec=TimeArray[3]>>16;
   string LocalTimeS = FormatDateTime(nYear,nMonth,nDay,nHour,nMin,nSec);
   datetime localTime = StrToTime( LocalTimeS );
   //-----------------------------------------------------  
   string GMTs = TimeToString( GMT );
   string locals = TimeToString( localTime  );
   string londons = TimeToString( london  );
   string frankfurts = TimeToString( frankfurt );
   string tokyos = TimeToString( tokyo  );
   string newyorks = TimeToString( newyork  );
   string sydneys = TimeToString ( sydney );
   string aucklands = TimeToString( auckland );
   string hongkongs = TimeToString( hongkong );
   string brokers = TimeToString( CurTime() );
   string bars = TimeToStr( CurTime() - Time[0], TIME_MINUTES );

//   DisplayTodaysNews();
   //-----------------------------------------------------
   LondonTZ = GMT_Offset("LONDON",localTime);   //GBP
   TokyoTZ = GMT_Offset("TOKYO",localTime);     //JPY
   NewYorkTZ = GMT_Offset("US",localTime);      //USD
   SydneyTZ = GMT_Offset("SYDNEY",localTime);   //AUD
   BerlinTZ = GMT_Offset("FRANKFURT",localTime);//EUR
   AucklandTZ = GMT_Offset("AUCKLAND",localTime);//NZD
   HongKongTZ = GMT_Offset("HONGKONG",localTime);//CNY
   //-----------------------------------------------------

   int gmt_shift=0;
   int dst=GetTimeZoneInformation(TZInfoArray);
   if(dst!=0) gmt_shift=TZInfoArray[0];
   if(dst==2) gmt_shift+=TZInfoArray[42];

   GMT = localTime + gmt_shift * 60;
   
   london = GMT + 3600 * LondonTZ;
   tokyo = GMT + 3600 * TokyoTZ;
   newyork = GMT + 3600 * NewYorkTZ;
   sydney = GMT + 3600 * SydneyTZ;
   frankfurt = GMT + 3600 * BerlinTZ;
   auckland = GMT +3600 * AucklandTZ;
   hongkong = GMT + 3600 * HongKongTZ;
   time_zone_gmt = -(gmt_shift/60);   
   
   DisplaySessionInfo();
   DisplayTodaysNews();  
   
   
   if ( ShowLocal ) {
      ObjectSetText( "locl", "Local time", 10, "Arial Black", labelColor );
      ObjectSetText( "loct", locals, 10, "Arial Black", ClockMktOpenColor );
     }
   if ( ShowBroker ) {
      ObjectSetText( "brol", "Broker time", 10, "Arial Black", labelColor );
      ObjectSetText( "brot", brokers, 10, "Arial Black", ClockMktOpenColor );
     }      
   if ( ShowGMT ) {
      ObjectSetText( "gmtl", "GMT", 10, "Arial Black", labelColor );
      ObjectSetText( "gmtt", GMTs, 10, "Arial Black", ClockMktOpenColor );
     }
//--------------------------
   if( Show_NEW_ZEALAND )
   {
    if (NZDHoliday < TimeCurrent())
    {
     if ((auckland > StrToTime ("10:00"))&& (auckland <  StrToTime("16:45"))&& TimeDayOfWeek(auckland) != 0 && TimeDayOfWeek(auckland) != 6)          
          {
           ObjectSetText( "NZDl", "New Zealand ", 10, "Arial Black", ClockMktOpenColor );
           ObjectSetText( "NZDt", aucklands, 10, "Arial Black", ClockMktOpenColor );   
          }
   	 else
          {
           ObjectSetText( "NZDl", "New Zealand ", 10, "Arial Black", labelColor );
           ObjectSetText( "NZDt", aucklands, 10, "Arial Black", clockColor );   
          }
    }
    if (NZDHoliday > TimeCurrent())
          {
           ObjectSetText( "NZDl", "New Zealand market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "NZDt", aucklands, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------
   if ( Show_AUSTRALIA )
   {
    if (AUDHoliday < TimeCurrent())    
   {
    if ((sydney > StrToTime ("10:00"))&& (sydney <  StrToTime("17:00"))&& TimeDayOfWeek(sydney) != 0 && TimeDayOfWeek(sydney) != 6)          
         {
          ObjectSetText( "sydl", "Australia ", 10, "Arial Black", ClockMktOpenColor );   
          ObjectSetText( "sydt", sydneys, 10, "Arial Black", ClockMktOpenColor );
         }
   	else
   	{
       ObjectSetText( "sydl", "Australia ", 10, "Arial Black", labelColor );
       ObjectSetText( "sydt", sydneys, 10, "Arial Black", clockColor );        
   	}
   }
    if (AUDHoliday > TimeCurrent())
          {
           ObjectSetText( "sydl", "Australia market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "sydt", sydneys, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------      
   if ( Show_JAPAN ) 
   {
    if (JPYHoliday < TimeCurrent())
   {
    if ((tokyo > StrToTime ("9:00"))&& (tokyo <  StrToTime("12:30"))&& TimeDayOfWeek(tokyo) != 0 && TimeDayOfWeek(tokyo) != 6)
         {
          ObjectSetText( "tokl", "Japan ", 10, "Arial Black", ClockMktOpenColor );
          ObjectSetText( "tokt", tokyos, 10, "Arial Black", ClockMktOpenColor );   
         }
      else
       if ((tokyo > StrToTime ("14:00"))&& (tokyo <  StrToTime("17:00"))&& TimeDayOfWeek(tokyo) != 0 && TimeDayOfWeek(tokyo) != 6)
         {
          ObjectSetText( "tokl", "Japan ", 10, "Arial Black", ClockMktOpenColor );
          ObjectSetText( "tokt", tokyos, 10, "Arial Black", ClockMktOpenColor );   
         }      
      else
      {
       ObjectSetText( "tokl", "Japan ", 10, "Arial Black", labelColor );
       ObjectSetText( "tokt", tokyos, 10, "Arial Black", clockColor );   
      }
   }
    if (JPYHoliday > TimeCurrent())
          {
           ObjectSetText( "tokl", "Japan market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "tokt", tokyos, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------         
   if (Show_HONG_KONG) 
   {
    if (CNYHoliday < TimeCurrent())
    {
     if ((hongkong > StrToTime ("10:00"))&& (hongkong <  StrToTime("17:00"))&& TimeDayOfWeek(hongkong) != 0 && TimeDayOfWeek(hongkong) != 6)   
         {
          ObjectSetText( "HKl", "Hong Kong ", 10, "Arial Black", ClockMktOpenColor );
          ObjectSetText( "HKt", hongkongs, 10, "Arial Black", ClockMktOpenColor );   
         }
   	else
   	{         
       ObjectSetText( "HKl", "Hong Kong ", 10, "Arial Black", labelColor );
       ObjectSetText( "HKt", hongkongs, 10, "Arial Black", clockColor );
      }
   }   
    if (CNYHoliday > TimeCurrent())
          {
           ObjectSetText( "HKl", "Hong Kong market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "HKt", hongkongs, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------   
   if (Show_EUROPE)
   {
    if (EURHoliday < TimeCurrent())
   {
    if ((frankfurt > StrToTime ("9:00"))&& (frankfurt <  StrToTime("17:30"))&& TimeDayOfWeek(frankfurt) != 0 && TimeDayOfWeek(frankfurt) != 6)
         {
          ObjectSetText( "berl", "Europe ", 10, "Arial Black", ClockMktOpenColor );
          ObjectSetText( "bert", frankfurts, 10, "Arial Black", ClockMktOpenColor );   
         }
   	else
   	{
       ObjectSetText( "berl", "Europe ", 10, "Arial Black", labelColor );
       ObjectSetText( "bert", frankfurts, 10, "Arial Black", clockColor );   
   	}
   }   
    if (EURHoliday > TimeCurrent())
          {
           ObjectSetText( "berl", "European market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "bert", frankfurts, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------      
   if (Show_LONDON)
   {
    if (GBPHoliday < TimeCurrent())
   {
    if ((london > StrToTime ("8:00"))&& (london <  StrToTime("17:00"))&& TimeDayOfWeek(london) != 0 && TimeDayOfWeek(london) != 6)          
         {
          ObjectSetText( "lonl", "UK ", 10, "Arial Black",ClockMktOpenColor );
          ObjectSetText( "lont", londons, 10, "Arial Black",ClockMktOpenColor );   
         }
   	else
   	{
       ObjectSetText( "lonl", "UK ", 10, "Arial Black", labelColor );
       ObjectSetText( "lont", londons, 10, "Arial Black", clockColor );  
   	}
   }
    if (GBPHoliday > TimeCurrent())
          {
           ObjectSetText( "lonl", "London market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "lont", londons, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------               
   if (Show_NEW_YORK)
   {
    if (USDHoliday < TimeCurrent())
   {
    if ((newyork > StrToTime ("8:00"))&& (newyork <  StrToTime("17:00"))&& TimeDayOfWeek(newyork) != 0 && TimeDayOfWeek(newyork) != 6)          
         {
          ObjectSetText( "nyl", "North America ", 10, "Arial Black",ClockMktOpenColor );
          ObjectSetText( "nyt", newyorks, 10, "Arial Black",ClockMktOpenColor );   
         }
   	else
   	{
       ObjectSetText( "nyl", "North America ", 10, "Arial Black", labelColor );
       ObjectSetText( "nyt", newyorks, 10, "Arial Black", clockColor ); 
   	}
   }
    if (USDHoliday > TimeCurrent())
          {
           ObjectSetText( "nyl", "New York market Holiday ", 10, "Arial Black", ClockMktHolidayClr );
           ObjectSetText( "nyt", newyorks, 10, "Arial Black", ClockMktHolidayClr );   
          }    
   }
//---------------------------                  
         
   ObjectSetText( "barl", "Bar time", 10, "Arial Black", labelColor );
   ObjectSetText( "bart", bars, 10, "Arial Black", clockColor );
   spread = NormalizeDouble((Ask - Bid) / Point, 0);
   ObjectSetText("Spread Monitor1", "Spread ", 10, "Arial Black", labelColor);
   ObjectSetText("Spread Monitor2", DoubleToStr(spread, 0), 10, "Arial Black", clockColor);   
//----  
   
   return(0);
}

// -----------------------------------------------------------------------------------------------------------------------------
int DisplayTodaysNews()
{
   string news[1000][10];
   datetime time = TimeCurrent();
   if(time >= lastUpdate+update_interval*60)  
   {   
     DeleteNewsObjects();
     string str = "";
     
     InitNews(news,time_zone_gmt,news_url );
     if(show_news_lines)
     {
      DrawNewsLines(news, show_line_text,news_high_color,news_medium_color,news_low_color);
     }
   } 
   ShowNewsCountDown(news,show_min_before_news,1, news_high_color,news_medium_color,news_low_color,news_past_color,session_upcoming_title_color);
   return(0);
}

// -----------------------------------------------------------------------------------------------------------------------------
string FormatDateTime(int nYear,int nMonth,int nDay,int nHour,int nMin,int nSec)
  {
   string sMonth,sDay,sHour,sMin,sSec;
//----
   sMonth=100+nMonth;
   sMonth=StringSubstr(sMonth,1);
   sDay=100+nDay;
   sDay=StringSubstr(sDay,1);
   sHour=100+nHour;
   sHour=StringSubstr(sHour,1);
   sMin=100+nMin;
   sMin=StringSubstr(sMin,1);
   sSec=100+nSec;
   sSec=StringSubstr(sSec,1);
//----
   return(StringConcatenate(nYear,".",sMonth,".",sDay," ",sHour,":",sMin,":",sSec));
  }
  
// -----------------------------------------------------------------------------------------------------------------------------
int Explode(string str, string delimiter, string& arr[])
{
   int i = 0;
   int pos = StringFind(str, delimiter);
   while(pos != -1)
   {
      if(pos == 0) arr[i] = ""; else arr[i] = StringSubstr(str, 0, pos);
      i++;
      str = StringSubstr(str, pos+StringLen(delimiter));
      pos = StringFind(str, delimiter);
      if(pos == -1 || str == "") break;
   }
   arr[i] = str;

   return(i+1);
}


// -----------------------------------------------------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------------------------------------------------
 
// Used to find out if news curreny is of interest to current symbol/chart. 
// Will have to be changed if symbol format does not look like for example eurusd or usdjpy
 
bool IsNewsCurrency(string cSymbol, string fSymbol)
{
   if(fSymbol == "usd") fSymbol = "USD";else
   if(fSymbol == "gbp") fSymbol = "GBP";else
   if(fSymbol == "eur") fSymbol = "EUR";else 
   if(fSymbol == "cad") fSymbol = "CAD";else
   if(fSymbol == "aud") fSymbol = "AUD";else
   if(fSymbol == "chf") fSymbol = "CHF";else
   if(fSymbol == "jpy") fSymbol = "JPY";else
   if(fSymbol == "cny") fSymbol = "CNY";else
   if(fSymbol == "nzd") fSymbol = "NZD";

   if((auto)&&(StringFind(cSymbol, fSymbol, 0)>=0)){return(true);}
   if(!auto && show_usd && fSymbol == "USD"){return(true);}
   if(!auto && show_gbp && fSymbol == "GBP"){return(true);}
   if(!auto && show_eur && fSymbol == "EUR"){return(true);}   
   if(!auto && show_cad && fSymbol == "CAD"){return(true);}
   if(!auto && show_aud && fSymbol == "AUD"){return(true);}   
   if(!auto && show_chf && fSymbol == "CHF"){return(true);}   
   if(!auto && show_jpy && fSymbol == "JPY"){return(true);}   
   if(!auto && show_nzd && fSymbol == "NZD"){return(true);}         
   if(!auto && show_cny && fSymbol == "CNY"){return(true);}
   return(false);
}

// ----------------------------------------------------------------------------------------------------------------------------- 
void InitNews(string& news[][],int timeZone, string newsUrl)
{
   if(DoFileDownLoad()) //Added to check if the CSV file already exists
         {
          DownLoadWebPageToFile(newsUrl); //downloading the CSV file
          lastUpdate=TimeCurrent();
         } 
     if(CsvNewsFileToArray(news) == 0) 
         return(0);
     
     NormalizeNewsData(news,timeZone);
}

// -----------------------------------------------------------------------------------------------------------------------------
bool DoFileDownLoad() // If we have recent file don't download again
{
 int handle;
 datetime time = TimeCurrent();
 handle=FileOpen(NewsFileName(), FILE_READ);  //commando to open the file
 if(handle>0)//when the file exists we read data
 {
   FileClose(handle);//close it again check is done
   if(time >= lastUpdate+update_interval*60)return(true);
   return(false);//file exists no need to download again
 }
 // File does not exist if FileOpen return -1 or if GetLastError = ERR_CANNOT_OPEN_FILE (4103)
 return(true); //commando true to download CSV file
}
 
// -----------------------------------------------------------------------------------------------------------------------------
void NormalizeNewsData(string& news[][], int timeDiffGmt, int startRow=1)
{
int totalNewsItems = ArrayRange( news, 0) - startRow ; 
   for( int i=0; i<totalNewsItems; i++)
      {      
         string tmp[3], tmp1[2];    
         Explode(news[i][COLUMN_DATE], " ", tmp);
         int mon = 0;
         if(tmp[COLUMN_DATE_MONTH_STR]=="Jan") mon=1; else 
         if(tmp[COLUMN_DATE_MONTH_STR]=="Feb") mon=2; else 
         if(tmp[COLUMN_DATE_MONTH_STR]=="Mar") mon=3; else 
         if(tmp[COLUMN_DATE_MONTH_STR]=="Apr") mon=4; else 
         if(tmp[COLUMN_DATE_MONTH_STR]=="May") mon=5; else 
         if(tmp[COLUMN_DATE_MONTH_STR]=="Jun") mon=6; else 
         if(tmp[COLUMN_DATE_MONTH_STR]=="Jul") mon=7; else
         if(tmp[COLUMN_DATE_MONTH_STR]=="Aug") mon=8; else
         if(tmp[COLUMN_DATE_MONTH_STR]=="Sep") mon=9; else
         if(tmp[COLUMN_DATE_MONTH_STR]=="Oct") mon=10; else
         if(tmp[COLUMN_DATE_MONTH_STR]=="Nov") mon=11; else
         if(tmp[COLUMN_DATE_MONTH_STR]=="Dec") mon=12;
         news[i][COLUMN_DATE] = Year()+"."+mon+"."+tmp[COLUMN_DATE_DAY_INT];
         
         if(news[i][COLUMN_TIME] == "")
         {
            news[i][COLUMN_TIME] = "00:00";
            news[i][COLUMN_TIMEZONE] = "ALL";
         }      
         datetime dt = StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME]);
         
         // Adjust for time zone
         
         dt   = dt + ((timeDiffGmt) * 3600);
         
         news[i][COLUMN_DATE] = TimeToStr(dt , TIME_DATE);
         news[i][COLUMN_TIME] = TimeToStr(dt , TIME_MINUTES);        
      }
} 


// -----------------------------------------------------------------------------------------------------------------------------
void DownLoadWebPageToFile(string url = "http://www.dailyfx.com/files/") // andre9@ya.ru
{
   if (url == "http://www.dailyfx.com/files/")
      url = StringConcatenate(url,NewsFileName(true));
      
   if(!IsDllsAllowed())
   {
      Alert("Please allow DLL imports");
      return("");
   }
   int result = InternetAttemptConnect(0);
   if(result != 0)
   {
      Alert("Cannot connect to internet - InternetAttemptConnect()");
      return("");
   }
   int hInternetSession = InternetOpenA("Microsoft Internet Explorer", 0, "", "", 0);
   if(hInternetSession <= 0)
   {
       Alert("Cannot open internet session - InternetOpenA()");
       return("");         
   }
   int hURL = InternetOpenUrlA(hInternetSession, 
              url, "", 0, 0, 0);
   if(hURL <= 0)
     {
       Alert("Cannot open URL ", url, " - InternetOpenUrlA()");
       InternetCloseHandle(hInternetSession);
       return(0);         
     }      
   int cBuffer[256];
   int dwBytesRead[1]; 
   string fileContents = "";
   while(!IsStopped())
   {
      for(int i = 0; i<256; i++) cBuffer[i] = 0;
      bool bResult = InternetReadFile(hURL, cBuffer, 1024, dwBytesRead);
      if(dwBytesRead[0] == 0) break;
      string text = "";   
      for(i = 0; i < 256; i++)
      {
         text = text + CharToStr(cBuffer[i] & 0x000000FF);
         if(StringLen(text) == dwBytesRead[0]) break;
         text = text + CharToStr(cBuffer[i] >> 8 & 0x000000FF);
         if(StringLen(text) == dwBytesRead[0]) break;
         text = text + CharToStr(cBuffer[i] >> 16 & 0x000000FF);
         if(StringLen(text) == dwBytesRead[0]) break;
         text = text + CharToStr(cBuffer[i] >> 24 & 0x000000FF);   
      }
      fileContents = fileContents + text;
      Sleep(1);
   }
   InternetCloseHandle(hInternetSession);
 // Save to text file  
 int handle;
 handle=FileOpen(NewsFileName(), FILE_CSV|FILE_WRITE, ';');
 if(handle>0)
 {
   FileWrite(handle, fileContents);
   FileClose(handle);
 }
}
// -----------------------------------------------------------------------------------------------------------------------------
// We will get news every sunday, so name file with sundays date
string NewsFileName(bool forDailyFXUrl =false)
{
   int adjustDays = 0;
   switch(TimeDayOfWeek(TimeLocal()))
   {
     case 0:
     adjustDays = 0;
     break;
     case 1:
     adjustDays = 1;
     break;
     case 2:
     adjustDays = 2;
     break;
     case 3:
     adjustDays = 3;
     break;
     case 4:
     adjustDays = 4;
     break;
     case 5:
     adjustDays = 5;
     break;
     case 6:
     adjustDays = 6;
     break;
   } 
   datetime date =  TimeLocal() - (adjustDays  * 86400);
   string fileName = "";
   if(TimeDayOfWeek(date) == 0)// sunday
   {
   if(forDailyFXUrl) // if we are building URL to get file from daily fx site.
   {
      fileName =  (StringConcatenate("Calendar-", PadString(DoubleToStr(TimeMonth(date),0),"0",2),"-",PadString(DoubleToStr(TimeDay(date),0),"0",2),"-",TimeYear(date),".csv"));
   }
   else
   {
      fileName =  (StringConcatenate(TimeYear(date),"-",PadString(DoubleToStr(TimeMonth(date),0),"0",2),"-",PadString(DoubleToStr(TimeDay(date),0),"0",2),"-News",".csv"));
   } 
   }
 return (fileName);  
}

// -----------------------------------------------------------------------------------------------------------------------------
string PadString(string toBePadded, string paddingChar, int paddingLength)
{
   while(StringLen(toBePadded) <  paddingLength)
   {
      toBePadded = StringConcatenate(paddingChar,toBePadded);
   }
   return (toBePadded);
}
// -----------------------------------------------------------------------------------------------------------------------------

int CsvNewsFileToArray(string& lines[][], int numDelimItems = 8, bool ignoreFirstLine = true, int freeTextCol = 4)
{
  int handle;
  handle=FileOpen(NewsFileName(),FILE_READ,",");
  if(handle>0)
  {
    int lineCount = 0;
    int lineNumber = 0;
    bool processedFirstLine = false;
    while(!FileIsEnding(handle))
    {
    string lineData = "";
         if(ArrayRange(lines, 0) > lineCount)
         {
            for(int itemCount = 0 ;itemCount <= numDelimItems; itemCount++)
            { 
               
               lineData = FileReadString(handle);
              
               if(ignoreFirstLine && lineCount > 0)
               {
               
                lineNumber = lineCount-1;
                lines[lineNumber][itemCount] = lineData ; 
          
                 if(itemCount == freeTextCol)
                  {
                     
                     for(int i = 0 ; i <10; i++)
                     {           
                        lineData = FileReadString(handle);               
                        if(lineData == "Low" || lineData == "Medium" || lineData == "LOW" || lineData == "High" || lineData == "HIGH")
                        {     
                          lines[lineNumber][freeTextCol+1] = lineData;
                          itemCount = freeTextCol+1;            
                          break; 
                        }  
                        else
                        {   
                           if(lineData != "")
                           {                        
                              lines[lineNumber][itemCount] = lines[lineNumber][itemCount] +", " + lineData;                     
                           } 
                        }                    
                     }  
                  }  
               }
            } 
         }        
         lineCount++;    
     }
    
    ArrayResize( lines, lineCount) ;
    FileClose(handle);
  }
  else if(handle<1)
  {
     Print("File ",NewsFileName(), " not found, the last error is ", GetLastError());   
  }
  
  return(lineCount);
}

// -----------------------------------------------------------------------------------------------------------------------------
int DeleteNewsObjects() 
{ 
   for(int i=0; i<1000; i++)
   {
      ObjectDelete("NewsLine"+i);
      ObjectDelete("NewsText"+i);
      ObjectDelete("NewsCountDown"+i);
   }   
   return(0); 
} 

// -----------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------
void DrawNewsLines(string news[][], bool showLineText, color high_color=Red,color medium_color=DarkOrange,color low_color=Blue,int startRow=1)
{
   datetime local = TimeLocal();
   datetime broker = TimeCurrent();
   datetime current = 0;
   double impact;
   bool skip;
   int totalNewsItems = ArrayRange( news, 0)- startRow;   
   if(Period() > PERIOD_H1)
              Print("Line text will only be shown for chart periods less than 4 hours");
      for( int i=0; i<totalNewsItems; i++) 
      {      
		 skip = false;
		    if(news[i][COLUMN_TIME] != news[i-1][COLUMN_TIME])impact=0;
          string newsCurrency = news[i][COLUMN_CURRENCY];
          if(!IsNewsCurrency(Symbol(),newsCurrency)){skip = true;}
          if (!show_high_news && (news[i][COLUMN_IMPORTANCE] == "High"||news[i][COLUMN_IMPORTANCE] == "HIGH")) 
			   {skip = true;}
		    if (!show_medium_news && news[i][COLUMN_IMPORTANCE] == "Medium") 
		   	{skip = true;}
		    if (!show_low_news && (news[i][COLUMN_IMPORTANCE] == "Low" || news[i][COLUMN_IMPORTANCE] == "LOW")) 
			   {skip = true;}
	       if (news[i][COLUMN_TIME] == "All Day" || 
			     news[i][COLUMN_TIME] == "Tentative" ||
			     news[i][COLUMN_TIME] == ""){skip = true;}
	    if (!skip)			      	    
        {
         if(ImpactToNumber(news[i][COLUMN_IMPORTANCE])>impact)impact=ImpactToNumber(news[i][COLUMN_IMPORTANCE]);  		   
         if(StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME]) == current) continue;
         current = (broker-local)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME]);
         color clr = low_color;
         if(impact == 2) clr = medium_color;  else
         if(impact == 3)clr = high_color;
         
         string text = "";
         if(news[i][COLUMN_PREVIOUS] != "" || news[i][COLUMN_FORECAST] != "") text = "[" + news[i][COLUMN_PREVIOUS] + ", " + news[i][COLUMN_FORECAST] + "]";
         if(news[i][COLUMN_IMPORTANCE] != "") text = text + " " + news[i][COLUMN_IMPORTANCE];
         
         
         ObjectCreate("NewsLine"+i, OBJ_VLINE, 0, current, 0);
         ObjectSet("NewsLine"+i, OBJPROP_COLOR, clr);
         ObjectSet("NewsLine"+i, OBJPROP_STYLE, STYLE_DASHDOTDOT);
         ObjectSet("NewsLine"+i, OBJPROP_BACK, true);          
         ObjectSetText("NewsLine"+i, news[i][COLUMN_DATE] + " " + news[i][COLUMN_DESCRIPTION] + " " + text, 8);         
         
         if (showLineText)
         {
            if(Period() < PERIOD_H4)
            {
               ObjectCreate("NewsText"+i, OBJ_TEXT, 0, current, WindowPriceMin()+(WindowPriceMax()-WindowPriceMin())*0.8 );
               ObjectSet("NewsText"+i, OBJPROP_COLOR, clr);
               ObjectSet("NewsText"+i, OBJPROP_ANGLE, 90);
               ObjectSetText("NewsText"+i, news[i][COLUMN_DATE] + " " + news[i][COLUMN_DESCRIPTION] + " " + text, 8);
            }
         }  
        }

      }              
}
// -----------------------------------------------------------------------------------------------------------------------------
double ImpactToNumber(string impact)
{
	if (impact == "High"||impact == "HIGH")
		return (3);
	if (impact == "Medium")
		return (2);
	if (impact == "Low"||impact == "LOW")
		return (1);
	else
		return (0);
}


// -----------------------------------------------------------------------------------------------------------------------------
void ShowNewsCountDown(string& news[][], int alertMinsBeforeNews=60,int startRow=1, color high_color=Red,
   color medium_color=DarkOrange,color low_color=Blue, color past_color=Gray, color title_color= Purple)
{
    bool skip;
    int alertBeforeNews = alertMinsBeforeNews*60;
    int totalNewsItems = ArrayRange( news, 0) - startRow; 
     for(int iCount=1; iCount<20; iCount++)
   { 
      ObjectDelete("NewsCountDown"+iCount);
      ObjectDelete("NewsCountDown"+iCount);
   }   
   int noOfAlerts = 0; 
    for(int i=0; i<totalNewsItems; i++)//looking to all newsitems
      {
       datetime newsDate = StrToTime(TimeToStr(StrToTime(news[i][COLUMN_DATE]), TIME_DATE) + " " + news[i][COLUMN_TIME]);
       if(TimeDay(newsDate) == TimeDay(TimeLocal()))//news for today
       {
		   skip = false;
		   if(StringFind(news[i][COLUMN_DESCRIPTION], "Bank Holiday", 0)>=0)
          {
           if(CurTime()>=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME]))
             {  
		        if(news[i][COLUMN_CURRENCY]=="NZD"){NZDHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="AUD"){AUDHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="JPY"){JPYHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="CNY"){CNYHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="EUR"){EURHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="GBP"){GBPHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="USD"){USDHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="nzd"){NZDHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="aud"){AUDHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="jpy"){JPYHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="cny"){CNYHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="eur"){EURHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="gbp"){GBPHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}
		        if(news[i][COLUMN_CURRENCY]=="usd"){USDHoliday=(CurTime()-localTime)+StrToTime(news[i][COLUMN_DATE]+" "+news[i][COLUMN_TIME])+86400;}   
             }
           }  
         int timediff = (newsDate - TimeLocal());// alertMinsBeforeNews display the minutes before news
         if(alertBeforeNews >= timediff && timediff >-3600) // display until 60 mins after news event
         {
          string newsCurrency = news[i][COLUMN_CURRENCY];
          if(!IsNewsCurrency(Symbol(),newsCurrency)){skip = true;}
          string importance = news[i][COLUMN_IMPORTANCE];          
          if (!show_high_news && (news[i][COLUMN_IMPORTANCE] == "High"||news[i][COLUMN_IMPORTANCE] == "HIGH")) 
			   {skip = true;}
		    if (!show_medium_news && news[i][COLUMN_IMPORTANCE] == "Medium") 
		   	{skip = true;}
		    if (!show_low_news && (news[i][COLUMN_IMPORTANCE] == "LOW" || news[i][COLUMN_IMPORTANCE] == "Low")) 
			   {skip = true;}
	       if (news[i][COLUMN_TIME] == "All Day" || 
			     news[i][COLUMN_TIME] == "Tentative" ||
			     news[i][COLUMN_TIME] == ""){skip = true;} 
			   
	       if (!skip)
              {   
               color textColor = low_color;
               if (news[i][COLUMN_IMPORTANCE] == "Medium")
                 {
                  textColor = medium_color;
                 }
               if (news[i][COLUMN_IMPORTANCE] == "High"||news[i][COLUMN_IMPORTANCE] == "HIGH")
                 {
                  textColor = high_color;        
                 }
                if(timediff < 0)
                  textColor = past_color;
  
                  noOfAlerts++;
                  int yDistance = 45 + (noOfAlerts*15);         
                  string timeDiffString = TimeToStr(MathAbs(timediff), TIME_MINUTES|TIME_SECONDS);
                  string description = StringSubstr( news[i][COLUMN_DESCRIPTION],0,40) + " " + timeDiffString;
                  ObjectCreate("NewsCountDown" + noOfAlerts, OBJ_LABEL, 0, 0, 0, 0, 0);
                  ObjectSet("NewsCountDown" + noOfAlerts, OBJPROP_CORNER, 1);
                  ObjectSet("NewsCountDown" + noOfAlerts, OBJPROP_XDISTANCE, 4);
                  ObjectSet("NewsCountDown" + noOfAlerts, OBJPROP_YDISTANCE,yDistance); 
                  ObjectSet("NewsCountDown" + noOfAlerts, OBJPROP_BACK,true);
                  ObjectSetText("NewsCountDown" + noOfAlerts,description ,10, "Arial Black", textColor);
                 }
             }
       }
       }
    if(noOfAlerts > 0)
    {
      ObjectCreate("NewsCountDown0", OBJ_LABEL, 0, 0, 0, 0, 0);
      ObjectSet("NewsCountDown0", OBJPROP_CORNER, 1);
      ObjectSet("NewsCountDown0", OBJPROP_XDISTANCE, 4);
      ObjectSet("NewsCountDown0", OBJPROP_YDISTANCE,45); 
      if (auto){ObjectSetText("NewsCountDown0","Your News Events this Currency",10, "Arial Black", title_color);}
      ObjectSetText("NewsCountDown0","Upcoming/Recent News Events",10, "Arial Black", title_color);
    }
}

// -----------------------------------------------------------------------------------------------------------------------------    
/////////////////////////////////////////////////////////////////////|
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GMT_Offset(string region,datetime dt1)
{
  int r1=0;
  if (region=="LONDON")    
    r1=GMT0(dt1);
  else if (region=="US")        
    r1=GMT_5(dt1);     
  else if (region=="FRANKFURT")        
    r1=GMT1(dt1);
  else if (region=="HONGKONG")        
    r1=GMT8(dt1);        
  else if (region=="TOKYO")        
    r1=GMT9(dt1);      
  else if (region=="SYDNEY")        
    r1=GMT11(dt1);          
  else if (region=="AUCKLAND")        
    r1=GMT12(dt1);   
      
    return (r1);
}


//+------------------------------------------------------------------+
//| London     DST ===  Standard and Summertime setting              |
//+------------------------------------------------------------------+
int GMT0(datetime dt1)
{
//UK Standard Time = GMT
//UK Summer Time = BST (British Summer time) = GMT+1
//For 2003-2007 inclusive, the summer-time periods begin and end respectively on 
//the following dates at 1.00am Greenwich Mean Time:
//2003: the Sundays of 30 March and 26 October
//2004: the Sundays of 28 March and 31 October
//2005: the Sundays of 27 March and 30 October
//2006: the Sundays of 26 March and 29 October
//2007: the Sundays of 25 March and 28 October
  if ((dt1>last_sunday(TimeYear(dt1),3))&&(dt1<last_sunday(TimeYear(dt1),10)))
   return(1);//summer
  else
   return(0); 
}

//+------------------------------------------------------------------+
//| Frankfurt     DST ===  Standard and Summertime setting           |
//+------------------------------------------------------------------+
int GMT1(datetime dt1)
{
//Standard Time = GMT +1
//Summer Time = GMT+2
//For 2003-2007 inclusive, the summer-time periods begin and end respectively on 
//the following dates at 1.00am Greenwich Mean Time:
//2003: the Sundays of 30 March and 26 October
//2004: the Sundays of 28 March and 31 October
//2005: the Sundays of 27 March and 30 October
//2006: the Sundays of 26 March and 29 October
//2007: the Sundays of 25 March and 28 October
  if ((dt1>last_sunday(TimeYear(dt1),3))&&(dt1<last_sunday(TimeYear(dt1),10)))
   return(2);//summer
  else
   return(1); 
}

//+------------------------------------------------------------------+
//| New York   US times                                              |
//+------------------------------------------------------------------+
int GMT_5(datetime dt1)
{
/*US
//-------------------------------------------------------------------
//Eastern Standard Time (EST) = GMT-5
//-------------------------------------------------------------------
//Eastern Daylight Time (EDT) = GMT-4
//-----+--------------------------+----------------------------------
//Year | 	DST Begins 2 a.m.     |     DST Ends 2 a.m.
//1990-|                          |
//2006 |  (First Sunday in April) |	(Last Sunday in October)
//-----+--------------------------+----------------------------------                                  
//-----+--------------------------+----------------------------------
//Year | 	DST Begins 2 a.m.     |     DST Ends 2 a.m.
//2007-|  (Second Sunday in March)|	(First Sunday in November)
//-----+--------------------------+----------------------------------
year     DST begins                 DST ends
2000     zondag, 2 april, 02:00     zondag, 29 oktober, 02:00
2001     zondag, 1 april, 02:00     zondag, 28 oktober, 02:00
2002     zondag, 7 april, 02:00     zondag, 27 oktober, 02:00
2003     zondag, 6 april, 02:00     zondag, 26 oktober, 02:00
2004     zondag, 4 april, 02:00     zondag, 31 oktober, 02:00
2005     zondag, 3 april, 02:00     zondag, 30 oktober, 02:00
2006     zondag, 2 april, 02:00     zondag, 29 oktober, 02:00

2007     zondag, 11 maart, 02:00    zondag, 4 november, 02:00
2008     zondag, 9 maart, 02:00     zondag, 2 november, 02:00
2009     zondag, 8 maart, 02:00     zondag, 1 november, 02:00
2010     zondag, 14 maart, 02:00    zondag, 7 november, 02:00
2011     zondag, 13 maart, 02:00    zondag, 6 november, 02:00
2012     zondag, 11 maart, 02:00    zondag, 4 november, 02:00
2013     zondag, 10 maart, 02:00    zondag, 3 november, 02:00
2014     zondag, 9 maart, 02:00     zondag, 2 november, 02:00
2015     zondag, 8 maart, 02:00     zondag, 1 november, 02:00
2016     zondag, 13 maart, 02:00    zondag, 6 november, 02:00
2017     zondag, 12 maart, 02:00    zondag, 5 november, 02:00
2018     zondag, 11 maart, 02:00    zondag, 4 november, 02:00
2019     zondag, 10 maart, 02:00    zondag, 3 november, 02:00
                                  
*/
 if(TimeYear(dt1)<2007)
   if ((dt1>sunday_number(TimeYear(dt1),4,1))&&(dt1<last_sunday(TimeYear(dt1),10)))
     return(-4);
    else
     return(-5); 
 else
 if(TimeYear(dt1)>=2007) 
   if ((dt1>sunday_number(TimeYear(dt1),3,2))&&(dt1<sunday_number(TimeYear(dt1),11,1)))
     return(-4);
    else
     return(-5); 
     
}
//+------------------------------------------------------------------+
//|  Hong Kong  CNY                                                  |
//+------------------------------------------------------------------+
int GMT8(datetime dt1)
{
   return(8);//standard NO DST =summer=+8
}

//+------------------------------------------------------------------+
//|  Tokyo  JPY                                                      |
//+------------------------------------------------------------------+
int GMT9(datetime dt1)
{
   return(9);//standard NO DST =summer=+9
}

//+------------------------------------------------------------------+
int GMT11(datetime dt1)
{
/*+------------------------------------------------------------------+
//|   Sydney    AUD                                                  |
//+------------------------------------------------------------------+
//|   Eastern Standard Time (EST) = GMT+10   No DST                  |
//|   Eastern Daylight Time (EDT) = GMT+11   DST                     |
//+-----+--------------------------+---------------------------------+
year     enddate                       startdate
2000     zondag, 26 maart, 03:00       zondag, 27 augustus, 02:00
2001     zondag, 25 maart, 03:00       zondag, 28 oktober, 02:00
2002     zondag, 31 maart, 03:00       zondag, 27 oktober, 02:00
2003     zondag, 30 maart, 03:00       zondag, 26 oktober, 02:00
2004     zondag, 28 maart, 03:00       zondag, 31 oktober, 02:00
2005     zondag, 27 maart, 03:00       zondag, 30 oktober, 02:00

2006     zondag, 2 april, 03:00        zondag, 29 oktober, 02:00

2007     zondag, 25 maart, 03:00       zondag, 28 oktober, 02:00

2008     zondag, 6 april, 03:00        zondag, 5 oktober, 02:00
2009     zondag, 5 april, 03:00        zondag, 4 oktober, 02:00
2010     zondag, 4 april, 03:00        zondag, 3 oktober, 02:00
2011     zondag, 3 april, 03:00        zondag, 2 oktober, 02:00
2012     zondag, 1 april, 03:00        zondag, 7 oktober, 02:00
2013     zondag, 7 april, 03:00        zondag, 6 oktober, 02:00
2014     zondag, 6 april, 03:00        zondag, 5 oktober, 02:00
2015     zondag, 5 april, 03:00        zondag, 4 oktober, 02:00
2016     zondag, 3 april, 03:00        zondag, 2 oktober, 02:00
2017     zondag, 2 april, 03:00        zondag, 1 oktober, 02:00
2018     zondag, 1 april, 03:00        zondag, 7 oktober, 02:00
2019     zondag, 7 april, 03:00        zondag, 6 oktober, 02:00

//-----+--------------------------+----------------------------------         
*/
 if(TimeYear(dt1)<1996)
   if ((dt1>sunday_number(TimeYear(dt1),3,1))&&(dt1<last_sunday(TimeYear(dt1),10)))
     return(10);
    else
     return(11); 
 else
 if((TimeYear(dt1)>=1996 && TimeYear(dt1)<2008)&&(TimeYear(dt1)!= 2006))
   if ((dt1>last_sunday(TimeYear(dt1),3))&&(dt1<last_sunday(TimeYear(dt1),10)))
     return(10);
    else
     return(11); 
 else
 if(TimeYear(dt1)== 2006)
   if ((dt1>sunday_number(TimeYear(dt1),4,1))&&(dt1<last_sunday(TimeYear(dt1),10)))
     return(10);
    else
     return(11); 
 else
 if(TimeYear(dt1)>=2008)
   if ((dt1>sunday_number(TimeYear(dt1),4,1))&&(dt1<sunday_number(TimeYear(dt1),10,1)))
     return(10);
    else
     return(11); 
}

//+------------------------------------------------------------------+
int GMT12(datetime dt1)
{
/*+------------------------------------------------------------------+
//|   New Zealand  Auckland   NZD                                    |
//+------------------------------------------------------------------+
//|   Eastern Standard Time (EST) = GMT+12   No DST                  |
//|   Eastern Daylight Time (EDT) = GMT+13   DST                     |
//+-----+--------------------------+---------------------------------+
year     enddate                       startdate
2000     zondag, 19 maart, 03:00       zondag, 1 oktober, 02:00
2001     zondag, 18 maart, 03:00       zondag, 7 oktober, 02:00
2002     zondag, 17 maart, 03:00       zondag, 6 oktober, 02:00
2003     zondag, 16 maart, 03:00       zondag, 5 oktober, 02:00
2004     zondag, 21 maart, 03:00       zondag, 3 oktober, 02:00
2005     zondag, 20 maart, 03:00       zondag, 2 oktober, 02:00
2006     zondag, 19 maart, 03:00       zondag, 1 oktober, 02:00

2007     zondag, 18 maart, 03:00       zondag, 30 september, 02:00
2008     zondag, 6 april, 03:00        zondag, 28 september, 02:00
2009     zondag, 5 april, 03:00        zondag, 27 september, 02:00
2010     zondag, 4 april, 03:00        zondag, 26 september, 02:00
2011     zondag, 3 april, 03:00        zondag, 25 september, 02:00
2012     zondag, 1 april, 03:00        zondag, 30 september, 02:00
2013     zondag, 7 april, 03:00        zondag, 29 september, 02:00
2014     zondag, 6 april, 03:00        zondag, 28 september, 02:00
2015     zondag, 5 april, 03:00        zondag, 27 september, 02:00
2016     zondag, 3 april, 03:00        zondag, 25 september, 02:00
2017     zondag, 2 april, 03:00        zondag, 24 september, 02:00
2018     zondag, 1 april, 03:00        zondag, 30 september, 02:00
2019     zondag, 7 april, 03:00        zondag, 29 september, 02:00

//-----+--------------------------+----------------------------------         
*/
 if(TimeYear(dt1)<2007)
   if ((dt1>sunday_number(TimeYear(dt1),3,3))&&(dt1<sunday_number(TimeYear(dt1),10,1)))
     return(12);
    else
     return(13); 
 else
 if(TimeYear(dt1)==2007)
   if ((dt1>sunday_number(TimeYear(dt1),3,3))&&(dt1<last_sunday(TimeYear(dt1),9)))
     return(12);
    else
     return(13); 
 else
 if(TimeYear(dt1)> 2007)
   if ((dt1>sunday_number(TimeYear(dt1),4,1))&&(dt1<last_sunday(TimeYear(dt1),10)))
     return(12);
    else
     return(13); 
     
   return(13);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool is_leap_year(int year1)
{
 
  if ((MathMod(year1,100)==0) && (MathMod(year1,400)==0))
    return(true);
  else if ((MathMod(year1,100)!=0) && (MathMod(year1,4)==0))  
    return(true);
  else 
    return (false); 
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int n_days(int year1,int month1)
{
  int ndays1;
  if (month1==1)
    ndays1=31;
  else if(month1==2)
  {
    if (is_leap_year(year1))
      ndays1=29;      
    else
      ndays1=28;  
  }    
  else if(month1==3)
    ndays1=31;  
  else if(month1==4)
    ndays1=30;  
  else if(month1==5)//mai
    ndays1=31;  
  else if(month1==6)//iun          
    ndays1=30;  
  else if(month1==7)//iul          
    ndays1=31;  
  else if(month1==8)//aug          
    ndays1=31;  
  else if(month1==9)//sep          
    ndays1=30;  
  else if(month1==10)//oct          
    ndays1=31;  
  else if(month1==11)//nov          
    ndays1=30;  
  else if(month1==12)          
    ndays1=31;  
  
  return(ndays1);

}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int n_sdays(int year1,int month1)
{
  datetime ddt2;
  int ndays2=n_days(year1,month1);
  int i,nsun1=0;  
  for (i=1;i<=ndays2;i++) 
  {
    ddt2= StrToTime(DoubleToStr(year1,0)+"."+DoubleToStr(month1,0)+"."+DoubleToStr(i,0)+" 00:00");            
    if(TimeDayOfWeek(ddt2)==0)
      nsun1=nsun1+1; 
  }   
  return(nsun1);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime last_sunday(int year1,int month1)
{
  int i,ndays2,nsun1,nsun2;
  datetime dt2,dt3;
  ndays2=n_days(year1,month1);
  nsun2=n_sdays(year1,month1);
  nsun1=0;
  for (i=1;i<=ndays2;i++) 
  {
    dt2= StrToTime(DoubleToStr(year1,0)+"."+DoubleToStr(month1,0)+"."+DoubleToStr(i,0)+" 00:00");                    
    if(TimeDayOfWeek(dt2)==0)
    {       
      nsun1=nsun1+1; 
    }  
    if (nsun1==nsun2) 
    {
      dt3=dt2;  
      break;        
    }  
  }   
  return(dt3);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

datetime sunday_number(int year1,int month1,int sundaycount)
{
  int i,ndays2,nsun1,nsun2;
  datetime dt2,dt3;
  ndays2=n_days(year1,month1);
  nsun2=sundaycount;//n_sdays(year1,month1);
  nsun1=0;
  for (i=1;i<=ndays2;i++) 
  {
    dt2= StrToTime(DoubleToStr(year1,0)+"."+DoubleToStr(month1,0)+"."+DoubleToStr(i,0)+" 00:00");                    
    if(TimeDayOfWeek(dt2)==0)
    {       
      nsun1=nsun1+1; 
    }  
    if (nsun1==nsun2) 
    {
      dt3=dt2;  
      break;        
    }  
  }   
  return(dt3);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplaySessionInfo()
{
   string openSessions = "Active sessions: ";
   string closingSession = "";
//----
// info from http://www.2011.worldmarkethours.com/Forex/index1024.htm
// New Zealand/Auckland.............: 10.00 - 16.45   localtimes timezone country
// Australia/Sydney local session...: 10.00 - 17.00
// Japan/Tokyo......................:  9.00 - 12.30    Re-opens  14.00 - 17.00 
// Hong Kong........................: 10.00 - 17.00
// Europe...........................:  9.00 - 17.30
// London local session.............: 08.00 - 17.00
// New York local session...........: 08.00 - 17.00


//New Zealand....: 10.00 - 16.45
if(NZDHoliday < TimeCurrent()){
  if ((auckland > StrToTime ("9:45"))&& (auckland <  StrToTime("10:00"))&& TimeDayOfWeek(auckland) != 0 && TimeDayOfWeek(auckland) != 6)
      {closingSession = "New Zealand opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}
  if ((auckland > StrToTime ("10:00"))&& (auckland <  StrToTime("16:45"))&& TimeDayOfWeek(auckland) != 0 && TimeDayOfWeek(auckland) != 6)
   {
      openSessions = openSessions + " New Zealand";
      if(TimeHour(auckland) == 16 && TimeMinute(auckland)>14 && TimeMinute(auckland)<45)
       {
         closingSession = "New Zealand closing in " + (45 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }     
//Australia...: 10.00 - 17.00
if(AUDHoliday < TimeCurrent()){   
  if ((sydney > StrToTime ("9:45"))&& (sydney <  StrToTime("10:00"))&& TimeDayOfWeek(sydney) != 0 && TimeDayOfWeek(sydney) != 6)
      {closingSession = "Australia opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}
  if ((sydney > StrToTime ("10:00"))&& (sydney <  StrToTime("17:00"))&& TimeDayOfWeek(sydney) != 0 && TimeDayOfWeek(sydney) != 6)
   {
       openSessions = openSessions + " Australia";
       if(TimeHour(sydney) == 16 && TimeMinute(sydney)>29)
       {
         closingSession = "Australia closing in " + (60 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }    
//Japan ....:  9.00 - 12.30    Re-opens  14.00 - 17.00
if(JPYHoliday < TimeCurrent()){
   if (tokyo >= StrToTime ("8:45") && tokyo <  StrToTime("9:00") && TimeDayOfWeek(tokyo) > 0 && TimeDayOfWeek(tokyo) < 6 )   
        {closingSession = "Tokyo first session opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}
   if (TimeHour(tokyo) >= 9 && TimeHour(tokyo) < 17 && TimeDayOfWeek(tokyo) > 0 && TimeDayOfWeek(tokyo) < 6 )
   {   
    if ((tokyo > StrToTime ("9:00"))&& (tokyo <  StrToTime("12:30"))&& TimeDayOfWeek(tokyo) != 0 && TimeDayOfWeek(tokyo) != 6)
       {openSessions = openSessions + " Tokyo";}
    if (tokyo >= StrToTime ("13:45") && tokyo <  StrToTime("14:00") && TimeDayOfWeek(tokyo) > 0 && TimeDayOfWeek(tokyo) < 6 )
       {closingSession = "Tokyo second session opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}          
    if ((tokyo > StrToTime ("14:00"))&& (tokyo <  StrToTime("17:00"))&& TimeDayOfWeek(tokyo) != 0 && TimeDayOfWeek(tokyo) != 6)       
       {openSessions = openSessions + " Tokyo";}
       if(TimeHour(tokyo) == 16 && TimeMinute(tokyo)>29)
       {
         closingSession = "Tokyo final closing in " + (60 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }     
//Hong Kong..: 10.00 - 17.00
if(CNYHoliday < TimeCurrent()){
    if ((hongkong > StrToTime ("10:00"))&& (hongkong <  StrToTime("17:00"))&& TimeDayOfWeek(hongkong) != 0 && TimeDayOfWeek(hongkong) != 6)
   {
       openSessions = openSessions + " Hong Kong";
       if(TimeHour(hongkong) == 16 && TimeMinute(hongkong)>29)
       {
         closingSession = "Hong Kong closing in " + (60 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }    
//Europe...:  9.00 - 17.30
if(EURHoliday < TimeCurrent()){
   if (frankfurt >= StrToTime ("8:45") && frankfurt <  StrToTime("9:00") && TimeDayOfWeek(london) > 0 && TimeDayOfWeek(london) < 6 )   
        {closingSession = "Europe opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}
    if ((frankfurt > StrToTime ("9:00"))&& (frankfurt <  StrToTime("17:30"))&& TimeDayOfWeek(frankfurt) != 0 && TimeDayOfWeek(frankfurt) != 6)
   {
       openSessions = openSessions + " Europe";
       if(TimeHour(frankfurt) == 17 && TimeMinute(frankfurt)<30)
       {
         closingSession = "Europe closing in " + (30 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }     
// London....: 08.00 - 17.00
if(GBPHoliday < TimeCurrent()){
   if (london >= StrToTime ("7:45") && london <  StrToTime("8:00") && TimeDayOfWeek(london) > 0 && TimeDayOfWeek(london) < 6 )   
        {closingSession = "London opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}
   if (TimeHour(london) >= 8 && TimeHour(london) < 17 && TimeDayOfWeek(london) > 0 && TimeDayOfWeek(london) < 6 )
   {      
         openSessions = openSessions + " London";
         if(TimeHour(london) == 16 && TimeMinute(london)>29)
       {
         closingSession = "London closing in " + (60 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }  
// New York....: 08.00 - 17.00
if(USDHoliday < TimeCurrent()){
   if (newyork >= StrToTime ("7:45") && newyork <  StrToTime("8:00") && TimeDayOfWeek(newyork) > 0 && TimeDayOfWeek(newyork) < 6 )   
        {closingSession = "New York opens in " + (60 - TimeMinute(TimeLocal()))+ " mins";}  
   if (TimeHour(newyork) >= 8 && TimeHour(newyork) < 17 && TimeDayOfWeek(newyork) > 0 && TimeDayOfWeek(newyork) < 6 )
   {
       openSessions = openSessions + " New York";
       if(TimeHour(newyork) == 16)
       {
         closingSession = "New York closing in " + (60 - TimeMinute(TimeLocal()))+ " mins";
       } 
   }
 }  
   
 string TimeLeft =  TimeToStr( (iTime(NULL,Period(),0)+Period()*60-TimeCurrent( )), TIME_MINUTES|TIME_SECONDS) ;
//----
   if(openSessions == "Active sessions: ") openSessions = "Markets Closed";
   ObjectSetText("OpenSessions", openSessions,12, "Arial Black", session_upcoming_title_color);
   ObjectSetText("BarClosing", "Time to bar close " + TimeLeft, 10, "Arial Black", bar_closing_color);
   ObjectSetText("SessionClosing",closingSession ,10, "Arial Black", session_closing_color);

}
//+------------------------------------------------------------------+ 

void CreateInfoObjects()
{
   ObjectCreate("OpenSessions", OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet("OpenSessions", OBJPROP_CORNER, 1);
   ObjectSet("OpenSessions", OBJPROP_XDISTANCE, 4);
   ObjectSet("OpenSessions", OBJPROP_YDISTANCE, 0);
   ObjectSetText("OpenSessions", "",12, "Arial Black", session_upcoming_title_color); 
    
   ObjectCreate("SessionClosing", OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet("SessionClosing", OBJPROP_CORNER, 1);
   ObjectSet("SessionClosing", OBJPROP_XDISTANCE, 4);
   ObjectSet("SessionClosing", OBJPROP_YDISTANCE, 15); 
    
   ObjectCreate("BarClosing", OBJ_LABEL, 0, 0, 0, 0, 0);
   ObjectSet("BarClosing", OBJPROP_CORNER, 1);
   ObjectSet("BarClosing", OBJPROP_XDISTANCE, 4);
   ObjectSet("BarClosing", OBJPROP_YDISTANCE,30); 
   ObjectSetText("BarClosing", "", 10, "Arial Black", bar_closing_color);  
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void DeleteSessionInfoObjects()
{
   ObjectDelete("OpenSessions");
   ObjectDelete("BarClosing");
   ObjectDelete("SessionClosing");  
}

//+------------------------------------------------------------------+
string TimeToString( datetime when ) {
   if ( !show12HourTime )
      return (TimeToStr( when, TIME_MINUTES ));      
   int hour = TimeHour( when );
   int minute = TimeMinute( when );
   
   string ampm = " AM";
   
   string timeStr;
   if ( hour >= 12 ) {
      hour = hour - 12;
      ampm = " PM";
   }
      
   if ( hour == 0 )
      hour = 12;
   timeStr = DoubleToStr( hour, 0 ) + ":";
   if ( minute < 10 )
      timeStr = timeStr + "0";
   timeStr = timeStr + DoubleToStr( minute, 0 );
   timeStr = timeStr + ampm;
   
   return (timeStr);
}
// -----------------------------------------------------------------------------------------------------------------------------

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int ObjectMakeLabel( string n, int xoff, int yoff ) {
   ObjectCreate( n, OBJ_LABEL, 0, 0, 0 );
   ObjectSet( n, OBJPROP_CORNER, Clockcorner );
   ObjectSet( n, OBJPROP_XDISTANCE, xoff );
   ObjectSet( n, OBJPROP_YDISTANCE, yoff );
   ObjectSet( n, OBJPROP_BACK, true );
} 


