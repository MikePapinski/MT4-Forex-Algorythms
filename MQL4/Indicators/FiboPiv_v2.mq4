
int start()
  {
   
//----
double rates[1][6],yesterday_close,yesterday_high,yesterday_low;
ArrayCopyRates(rates, Symbol(), PERIOD_D1);
 
if(DayOfWeek() == 1)
{
   if(TimeDayOfWeek(iTime(Symbol(),PERIOD_D1,1)) == 5)
   {
       yesterday_close = rates[1][4];
       yesterday_high = rates[1][3];
       yesterday_low = rates[1][2];
   }
   else
   {
      for(int d = 5;d>=0;d--)
      {
         if(TimeDayOfWeek(iTime(Symbol(),PERIOD_D1,d)) == 5)
         {
             yesterday_close = rates[d][4];
             yesterday_high = rates[d][3];
             yesterday_low = rates[d][2];
         }
         
      }  
   }
}
else
{
    yesterday_close = rates[1][4];
    yesterday_high = rates[1][3];
    yesterday_low = rates[1][2];
}


//---- Calculate Pivots

Comment("\nYesterday quotations:\nH ",yesterday_high,"\nL ",yesterday_low, "\nC ",yesterday_close);
double R = yesterday_high - yesterday_low;//range
double p = (yesterday_high + yesterday_low + yesterday_close)/3;// Standard Pivot
double r3 = p + (R * 1.000);
double r2 = p + (R * 0.618);
double r1 = p + (R * 0.382);
double s1 = p - (R * 0.382);
double s2 = p - (R * 0.618);
double s3 = p - (R * 1.000);

drawLine(r3,"R3", Lime,0);
drawLabel("Resistance 3",r3,Lime);
drawLine(r2,"R2", Green,0);
drawLabel("Resistance 2",r2,Green);
drawLine(r1,"R1", DarkGreen,0);
drawLabel("Resistance 1",r1,DarkGreen);

drawLine(p,"PIVIOT",Blue,1);
drawLabel("Piviot level",p,Blue);

drawLine(s1,"S1",Maroon,0);
drawLabel("Support 1",s1,Maroon);
drawLine(s2,"S2",Crimson,0);
drawLabel("Support 2",s2,Crimson);
drawLine(s3,"S3",Red,0);
drawLabel("Support 3",s3,Red);


//----
   return(0);
  }
//+------------------------------------------------------------------+
