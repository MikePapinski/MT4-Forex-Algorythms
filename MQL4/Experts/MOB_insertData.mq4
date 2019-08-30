//+------------------------------------------------------------------+
//|                                               MOB_insertData.mq4 |
//|                                                     Osamu Nagano |
//|                   http://www.google.com/profiles/onagano.g#about |
//+------------------------------------------------------------------+
#property copyright "Osamu Nagano"
#property link      "http://www.google.com/profiles/onagano.g#about"

#import "mt4odbcbridge.ex4"
void     mob_create();
int      mob_open(string dsn, string username, string password);
int      mob_close();
int      mob_isDead();
int		mob_commit();
int		mob_rollback();
int		mob_getAutoCommit();
int		mob_setAutoCommit(int autoCommit);
int      mob_execute(string sql);
int      mob_getLastErrorNo();
string   mob_getLastErrorMesg();
int      mob_registerStatement(string sql);
int      mob_unregisterStatement(int stmtId);
int		mob_bindIntParameter(int stmtId, int slot, int intp[]);
int		mob_bindDoubleParameter(int stmtId, int slot, double dblp[]);
int		mob_bindStringParameter(int stmtId, int slot, string strp);
int		mob_bindDatetimeParameter(int stmtId, int slot, datetime dtp[]);
int      mob_executeStatement(int stmtId);
int      mob_insertTick(int stmtId, datetime dt, int fraction, double vals[]);
int      mob_insertBar(int stmtId, datetime dt, double vals[]);
int      mob_copyRates(int stmtId, double rates[][6], int size, int start, int end);
double   mob_selectDouble(string sql, double defaultVal);
int      mob_selectInt(string sql, int defaultVal);
datetime mob_selectDatetime(string sql, datetime defaultVal);
int      createTableIfNotExists(string tableName, string sql);
string   getPeriodSymbol(int period_XX);
datetime mob_time();
int      mob_strcpy(string dest, int size, string src);
#import

//---- input parameters
extern string    ExtDataSourceName = "fxddx";
extern string    ExtUsername       = "";
extern string    ExtPassword       = "";
extern string    ExtTablePrefix    = "MOB_";
extern bool      ExtAccumTickData  = false;

int      insertTick;
int      insertBar;
datetime lastTickTime;
int      lastTickFraction;
datetime lastBarTime;
datetime lastGMTime;

string marketTable = "MARKET";
int updateMarketStmt = 0;

string   mktSymbol = "A123456789";
int      mktSymbolSize;
datetime mktTime[1];
int      mktFraction[1];
double   mktBid[1];
double   mktAsk[1];
double   mktSpread[1];

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
   if (!IsDllsAllowed()) {
      Alert("ERROR: [Allow DLL imports] NOT Checked.");
      return (-1);
   }
//----
   mob_create();
   int rc;
   
   rc = mob_open(ExtDataSourceName, ExtUsername, ExtPassword);
   if (rc < 0) return (rc);

   rc = mob_setAutoCommit(true);
   if (rc < 0) return (rc);
   
   // Prepare tick table
   if (ExtAccumTickData) {
      string tickTable = ExtTablePrefix + getDefaultTableName(false);
      rc = prepareTable(tickTable, false);
      if (rc < 0) return (rc);
   }
   
   // Prepare bar table
   string barTable = ExtTablePrefix + getDefaultTableName(true);
   rc = prepareTable(barTable, true);
   if (rc < 0) return (rc);
	
	// Prepare Market table
	marketTable = ExtTablePrefix + marketTable;
	rc = prepareMarketTable(marketTable, Symbol());
   if (rc < 0) return (rc);
	
	lastTickTime = TimeCurrent();
	lastTickFraction = GetTickCount() % 1000;
	lastBarTime = TimeCurrent();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   // Insert the very last bar if the time passed enough.
   datetime currentGMTime = mob_time();
   if ((currentGMTime - lastGMTime) >= Period() * 60) {
      insertBarAt(0);
   }

   int rc = mob_close();
   if (rc < 0) return (rc);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (ExtAccumTickData) startTick();
   updateMarket();
   startBar();
   lastGMTime = mob_time();
//----
   return(0);
  }
//+------------------------------------------------------------------+

int prepareTable(string tableName, bool isBar) {
   int rc;
   
   rc = createTableIfNotExists2(tableName, isBar);
   if (rc < 0) return (rc);
   
	rc = mob_registerStatement(insertSQL(tableName, isBar));
   if (rc < 0) return (rc);
   
   if (isBar)
      insertBar = rc;
   else
      insertTick = rc;
   
   return (0);
}

int startTick() {
   datetime dt = TimeCurrent();
   int fraction  = GetTickCount() % 1000;
   double tickData[2];
   tickData[0] = Ask;
   tickData[1] = Bid;
   
   if (dt == lastTickTime && fraction <= lastTickFraction) {
      // Ensure the primary key is unique.
      fraction = lastTickFraction + 1;
   }
   
   int rc = mob_insertTick(insertTick, dt, fraction, tickData);
   if (rc < 0) return (rc);
   lastTickTime = dt;
   lastTickFraction = fraction;

   return (0);
}

int startBar() {
   datetime dt = Time[1];
   
   if (lastBarTime < dt) {
      lastBarTime = dt;
      
      int rc = insertBarAt(1);
      if (rc < 0) return (rc);
   }
   
   return (0);
}

int insertBarAt(int i) {
   double barData[5];
   datetime dt = Time[i];
   barData[0] = Open[i];
   barData[1] = High[i];
   barData[2] = Low[i];
   barData[3] = Close[i];
   barData[4] = Volume[i];

   int rc = mob_insertBar(insertBar, dt, barData);
   return (rc);
}

int createTableIfNotExists2(string tableName, bool isBar = true, bool drop = false) {
   int rc = 0;
 
   if (drop) rc = mob_execute("drop table " + tableName);
   
   rc = mob_selectInt("select count(*) from " + tableName, -1);
   bool exist = 0 <= rc;
   
   if (!exist) {
      if (isBar)
         rc = mob_execute(barTableSQL(tableName));
      else
         rc = mob_execute(tickTableSQL(tableName));
   }
   
   return (rc);
}

string barTableSQL(string tableName) {
   string sql;
   sql = "create table " + tableName + " ("
      + "  time timestamp"
      + ", open double precision"
      + ", high double precision"
      + ", low double precision"
      + ", close double precision"
      + ", volume double precision"
      + ", primary key (time)"
      + ")";
   return (sql);
}

string tickTableSQL(string tableName) {
   string sql;
   sql = "create table " + tableName + " ("
      + "  time timestamp"
      + ", fraction integer"
      + ", ask double precision"
      + ", bid double precision"
      + ", primary key (time, fraction)"
      + ")";
   return (sql);
}

string insertSQL(string tableName, bool isBar = true) {
   string sql;
   if (isBar)
      sql = insertBarSQL(tableName);
   else
      sql = insertTickSQL(tableName);
   return (sql);
}

string insertBarSQL(string tableName) {
   string sql;
   sql = "insert into " + tableName
      + " (time, open, high, low, close, volume) values (?, ?, ?, ?, ?, ?)";
   return (sql);
}

string insertTickSQL(string tableName) {
   string sql;
   sql = "insert into " + tableName
      + " (time, fraction, ask, bid) values (?, ?, ?, ?)";
   return (sql);
}

string getDefaultTableName(bool isBar = true) {
   if (isBar)
      return (Symbol() + "_" + getPeriodSymbol(Period()));
   else
      return (Symbol() + "_TICK");
}

int prepareMarketTable(string tableName, string symbol) {
   int rc = 0;
   
   rc = createTableIfNotExists(tableName, marketTableSQL(tableName));
   if (rc < 0) return (rc);

   rc = mob_selectInt("select count(*) from " + tableName
                     + " where symbol = '" + symbol + "'", -1);
   if (rc != 1) {
      rc = mob_execute("insert into " + tableName
                     + " (symbol) values ('" + symbol + "')");
   }

   // Regstering update market statement   
   rc = mob_registerStatement(updateMarketSQL(tableName));
   if (rc < 0) return (rc);
   updateMarketStmt = rc;

   int i = 1;
   mob_bindDatetimeParameter  (updateMarketStmt, i, mktTime);      i++;
   mob_bindIntParameter       (updateMarketStmt, i, mktFraction);  i++;
   mob_bindDoubleParameter    (updateMarketStmt, i, mktBid);       i++;
   mob_bindDoubleParameter    (updateMarketStmt, i, mktAsk);       i++;
   mob_bindDoubleParameter    (updateMarketStmt, i, mktSpread);    i++;
   mob_bindStringParameter    (updateMarketStmt, i, mktSymbol);    i++;
   mktSymbolSize = StringLen(mktSymbol);
   
   mob_strcpy(mktSymbol, mktSymbolSize, symbol);
   
   return (0);
}

string marketTableSQL(string tableName) {
   string sql = "create table " + tableName + " ("
      + "  symbol varchar(10) primary key"
      + ", time timestamp"
      + ", fraction integer"
      + ", bid double precision"
      + ", ask double precision"
      + ", spread double precision"
      + ")";
   return (sql);
}

string updateMarketSQL(string tableName) {
   string sql = "update " + tableName
      + " set time = ?, fraction = ?, bid = ?, ask = ?, spread = ?"
      + " where symbol = ?";
   return (sql);
}

int updateMarket() {
   int rc = 0;

   mktTime[0] = TimeCurrent();
   mktFraction[0]  = GetTickCount() % 1000;
   mktBid[0] = Bid;
   mktAsk[0] = Ask;
   mktSpread[0] = MarketInfo(mktSymbol, MODE_SPREAD);
   
   rc = mob_executeStatement(updateMarketStmt);
   if (rc < 0) return (rc);

   return (rc);
}

