//+------------------------------------------------------------------+
//|                                                   SymbolsLib.mq4 |
//|                                          Copyright © 2009, Ilnur |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+

//    Библиотека функций для работы с финансовыми инструментами,
// загруженными в торговый терминал.

#property copyright "Copyright © 2009, Ilnur"
#property link      "http://www.metaquotes.net"
#property library

//+------------------------------------------------------------------+
//| Функция возвращает список доступных символов                     |
//+------------------------------------------------------------------+
int SymbolsList(string &Symbols[], bool Selected)
{
   string SymbolsFileName;
   int Offset, SymbolsNumber;
   
   if(Selected) SymbolsFileName = "symbols.sel";
   else         SymbolsFileName = "symbols.raw";
   
// Открываем файл с описанием символов

   int hFile = FileOpenHistory(SymbolsFileName, FILE_BIN|FILE_READ);
   if(hFile < 0) return(-1);

// Определяем количество символов, зарегистрированных в файле

   if(Selected) { SymbolsNumber = (FileSize(hFile) - 4) / 128; Offset = 116;  }
   else         { SymbolsNumber = FileSize(hFile) / 1936;      Offset = 1924; }

   ArrayResize(Symbols, SymbolsNumber);

// Считываем символы из файла

   if(Selected) FileSeek(hFile, 4, SEEK_SET);
   
   for(int i = 0; i < SymbolsNumber; i++)
   {
      Symbols[i] = FileReadString(hFile, 12);
      FileSeek(hFile, Offset, SEEK_CUR);
   }
   
   FileClose(hFile);
   
// Возвращаем количество считанных инструментов

   return(SymbolsNumber);
}

//+------------------------------------------------------------------+
//| Функция возвращает расшифрованное название символа               |
//+------------------------------------------------------------------+
string SymbolDescription(string SymbolName)
{
   string SymbolDescription = "";
   
// Открываем файл с описанием символов

   int hFile = FileOpenHistory("symbols.raw", FILE_BIN|FILE_READ);
   if(hFile < 0) return("");

// Определяем количество символов, зарегистрированных в файле

   int SymbolsNumber = FileSize(hFile) / 1936;

// Ищем расшифровку символа в файле

   for(int i = 0; i < SymbolsNumber; i++)
   {
      if(FileReadString(hFile, 12) == SymbolName)
      {
         SymbolDescription = FileReadString(hFile, 64);
         break;
      }
      FileSeek(hFile, 1924, SEEK_CUR);
   }
   
   FileClose(hFile);
   
   return(SymbolDescription);
}

//+------------------------------------------------------------------+
//| Функция определяет тип инструмента                               |
//+------------------------------------------------------------------+
string SymbolType(string SymbolName)
{
   int GroupNumber = -1;
   string SymbolGroup = "";
   
// Открываем файл с описанием символов

   int hFile = FileOpenHistory("symbols.raw", FILE_BIN|FILE_READ);
   if(hFile < 0) return("");
   
// Определяем количество символов, зарегистрированных в файле
   
   int SymbolsNumber = FileSize(hFile) / 1936;
   
// Ищем символ в файле
   
   for(int i = 0; i < SymbolsNumber; i++)
   {
      if(FileReadString(hFile, 12) == SymbolName)
      {
      // Определяем номер группы
         
         FileSeek(hFile, 1936*i + 100, SEEK_SET);
         GroupNumber = FileReadInteger(hFile);
         
         break;
      }
      FileSeek(hFile, 1924, SEEK_CUR);
   }
   
   FileClose(hFile);
   
   if(GroupNumber < 0) return("");
   
// Открываем файл с описанием групп
   
   hFile = FileOpenHistory("symgroups.raw", FILE_BIN|FILE_READ);
   if(hFile < 0) return("");
   
   FileSeek(hFile, 80*GroupNumber, SEEK_SET);
   SymbolGroup = FileReadString(hFile, 16);
   
   FileClose(hFile);
   
   return(SymbolGroup);
}