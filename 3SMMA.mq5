#property copyright "Copyright 2024, Okoth Kuzan"
#property link      "https://www.yourwebsite.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots  3
//--- the 3SMMA plot
#property indicator_label1  "SMMA 1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
#property indicator_label2  "SMMA 2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLime
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
#property indicator_label3  "SMMA 3"
#property indicator_type3  DRAW_LINE
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1

//+------------------------------------------------------------------+
//| Enumeration of the methods of handle creation                    |
//+------------------------------------------------------------------+
enum Creation
  {
   Call_iMA,               // use iMA
   Call_IndicatorCreate    // use IndicatorCreate
  };
//--- input parameters
input Creation             type=Call_iMA;                // type of the function 
input int                  ma_period1=60;                 // period of ma
input int                  ma_period2=100;                 // period of ma
input int                  ma_period3=200;                 // period of ma
input int                  ma_shift=0;                   // shift
input ENUM_MA_METHOD       ma_method=MODE_SMMA;           // type of smoothing
input ENUM_APPLIED_PRICE   applied_price=PRICE_CLOSE;    // type of price
input string               symbol=" ";                   // symbol 
input ENUM_TIMEFRAMES      period=PERIOD_CURRENT;        // timeframe
//--- indicator buffer
double         SMMA1Buffer[];
double         SMMA2Buffer[];
double         SMMA3Buffer[];
//--- variable for storing the handle of the iMA indicator
int    handle;
//--- variable for storing
string name=symbol;
//--- we will keep the number of values in the Moving Average indicator
int    bars_calculated=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Set up the indicator buffers
   if (!SetIndexBuffer(0, SMMA1Buffer, INDICATOR_DATA) ||
       !SetIndexBuffer(1, SMMA2Buffer, INDICATOR_DATA) ||
       !SetIndexBuffer(2, SMMA3Buffer, INDICATOR_DATA))
   {
      Print("Failed to set up indicator buffers! Error code: ", GetLastError());
      return INIT_FAILED;
   }

   // Set plot properties
   for (int i = 0; i < 3; i++)
   {
      PlotIndexSetInteger(i, PLOT_DRAW_TYPE, DRAW_LINE);
      PlotIndexSetInteger(i, PLOT_LINE_STYLE, STYLE_SOLID);
      PlotIndexSetInteger(i, PLOT_LINE_WIDTH, 1);
   }

   // Set indicator labels
   IndicatorSetString(INDICATOR_SHORTNAME, "3SMMA");

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if (rates_total <= 0)
   {
      Print("No rates available for calculation!");
      return 0;
   }

   int startIdx = rates_total - prev_calculated - 1;

   // Calculate SMMA for each set of parameters
   for (int i = startIdx; i >= 0; i--)
   {
      if (i < ma_period3 - 1)
         continue; // Not enough data for calculation

      SMMA1Buffer[i] = smma(close[i], ma_period1, SMMA1Buffer);
      SMMA2Buffer[i] = smma(close[i], ma_period2, SMMA2Buffer);
      SMMA3Buffer[i] = smma(close[i], ma_period3, SMMA3Buffer);
   }

   return (rates_total);
}

//+------------------------------------------------------------------+
//| Function to calculate SMMA                                       |
//+------------------------------------------------------------------+
double smma(double source, int length, double &array[])
{
   double smmaValue = 0.0;

   // If array is not initialized, calculate simple moving average
   if (ArraySize(array) == 0)
   {
      ArrayResize(array, length);
      for (int i = 0; i < length; i++)
      {
         array[i] = iClose(_Symbol, PERIOD_CURRENT, i);
         smmaValue += array[i];
      }
      smmaValue /= length;
   }
   else
   {
      // Update SMMA value
      smmaValue = (array[0] * (length - 1) + source) / length;

      // Shift array elements to the right
      for (int i = length - 1; i > 0; i--)
         array[i] = array[i - 1];

      // Update the first element with the new source value
      array[0] = source;
   }

   return smmaValue;
}
