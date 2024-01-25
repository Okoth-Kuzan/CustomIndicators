//+------------------------------------------------------------------+
//|                                                        3SMMA.mq5 |
//|                                                      Okoth Kuzan |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Okoth Kuzan"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_plots 3

// Input parameters for the three SMMA
input int length1 = 60;
input int length2 = 100;
input int length3 = 200;

// Define data series for the three SMMA
double smma1[];
double smma2[];
double smma3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
// Set up the indicator buffers
   SetIndexBuffer(0, smma1);
   SetIndexBuffer(1, smma2);
   SetIndexBuffer(2, smma3);

   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   
   PlotIndexSetInteger(0, PLOT_LINE_COLOR, Blue);
   PlotIndexSetInteger(1, PLOT_LINE_COLOR, Lime);
   PlotIndexSetInteger(2, PLOT_LINE_COLOR, Red);

   return(INIT_SUCCEEDED);
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
// Calculate SMMA for each set of parameters
   smma1[0] = smma(close[0], length1, smma1);
   smma2[0] = smma(close[0], length2, smma2);
   smma3[0] = smma(close[0], length3, smma3);

// Print the values for debugging purposes
   Print("SMMA 1: ", smma1[0]);
   Print("SMMA 2: ", smma2[0]);
   Print("SMMA 3: ", smma3[0]);

//--- return value of prev_calculated for the next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
//| Function to calculate SMMA                                       |
//+------------------------------------------------------------------+
double smma(double source, int length, double &array[])
  {
   double smmaValue = 0.0;

// If array is not initialized, calculate simple moving average
   if(ArraySize(array) == 0)
     {
      ArrayResize(array, length);
      for(int i = 0; i < length; i++)
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
      for(int i = length - 1; i > 0; i--)
         array[i] = array[i - 1];

      // Update the first element with the new source value
      array[0] = source;
     }

   return smmaValue;
  }
//+------------------------------------------------------------------+
