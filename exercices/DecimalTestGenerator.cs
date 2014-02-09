/*                                                                           */
/* File:       DecimalTestGenerator.cs                                       */
/* Function:   Generates result tables for a set of decimals and the math    */
/*             operations on them, as an include file for the                */
/*             DecimalTest.dpr program, called DecimalTestData.inc.          */
/* Language:   C# 2.0 or above                                               */
/* Author:     Rudy Velthuis                                                 */
/* Copyright:  (c) 2010 Rudy Velthuis                                        */
/* Notes:      Can be compiled with the freely available Microsoft C#        */
/*             Express IDE or with RAD Studio 2007.                          */
/*             See http://rvelthuis.de/programs/decimal.html                 */
/*                                                                           */
/* Disclaimer: This code is freeware. All rights are reserved.               */
/*             This code is provided as is, expressly without a warranty     */
/*             of any kind. You use it at your own risk.                     */
/*                                                                           */
/*             If you use this code, please credit me.                       */
/*                                                                           */

using System;
using System.IO;

namespace DecimalTestResults
{
    public enum TestResultInfo
    {
        Ok = 0,
        Overflow = 1,
        ReverseRound = 2,
        DivideByZero = 3,
        ReverseOverflow = 4
    }

    public struct TestResult
    {
        public TestResult(int i, decimal v)
        {
            info = (TestResultInfo)i;
            val = v;
        }

        public TestResultInfo info;
        public decimal val;
    }

    class ResultGenerator
    {
        static void Main(string[] args)
        {
            using (StreamWriter sw = new StreamWriter("..\\..\\..\\..\\DecimalTestData.inc"))
            {
                WriteData(sw);
                WriteComparisons(sw);
                WriteAdditions(sw);
                WriteMultiplications(sw);
                WriteDivisions(sw);
                WriteRemainders(sw);
            }

            Console.WriteLine();
            Console.Write("Press any key...");
            Console.ReadKey();
        }

        static void WriteData(TextWriter tw)
        {
            int count = testData.Length;

            tw.WriteLine("const");
            tw.WriteLine("  TestCount = {0};", count);
            tw.WriteLine("  Arguments: array[0..TestCount - 1] of string =");
            tw.WriteLine("  (");
            for (int i = 0; i < count; ++i)
                tw.WriteLine("    {0,-36} // {1}", 
                    "'" + testData[i].ToString().Replace(",", ".") + ((i < count - 1) ? "'," : "'"), i);
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void WriteResults(TextWriter tw, string ArrayName, TestResult[] results, int count, string op)
        {
            tw.WriteLine("  {0}: array[0..TestCount * TestCount - 1] of TTestResult =", ArrayName);
            tw.WriteLine("  (");
            int n = 0;
            for (int i = 0; i < count; ++i)
                for (int j = 0; j < count; ++j, ++n)
                {
                    string infos = String.Format("tri{0};", results[n].info);
                    string vals = String.Format("'{0}'){1}",
                        results[n].val.ToString("G29").Replace(",", "."),
                        (n < count * count - 1) ? "," : "");
                    tw.WriteLine("    (info: {0,-19} val: {1,-35} // {2} {3} {4}", infos, vals, i, op, j);
                }
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void WriteComparisons(TextWriter tw)
        {
            decimal[] data = compData;
            int count = data.Length;
            int result = 0;

            tw.WriteLine("  CompCount = {0};", count);
            tw.WriteLine("  CompArguments: array[0..CompCount - 1] of string =");
            tw.WriteLine("  (");
            for (int i = 0; i < count; ++i)
                tw.WriteLine("    {0,-36} // {1}", 
                    "'" + compData[i].ToString().Replace(",", ".") + ((i < count - 1) ? "'," : "'"), i);
            tw.WriteLine("  );");
            tw.WriteLine();
            tw.WriteLine("  CompResults: array[0..CompCount - 1, 0..CompCount - 1] of TValueSign =", count - 1);
            tw.WriteLine("  (");
            int n = 0;
            for (int i = 0; i < count; ++i)
            {
                tw.Write("    (");
                decimal d1 = data[i];
                for (int j = 0; j < count; ++j, ++n)
                {
                    decimal d2 = data[j];
                    result = Decimal.Compare(d1, d2);
                    if (result < 0)
                        tw.Write("-1");
                    else if (result > 0)
                        tw.Write(" 1");
                    else
                        tw.Write(" 0");
                    if (j < count - 1)
                        tw.Write(", ");
                }
                tw.Write(")");
                if (i < count - 1)
                    tw.Write(",");
                tw.WriteLine();
            }
            tw.WriteLine("  );");
            tw.WriteLine();
        }

        static void WriteRemainders(TextWriter tw)
        {
            decimal[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {

                decimal d1 = data[i];
                for (int j = 0; j < count; ++j, ++n)
                {
                    decimal d2 = data[j];
                    decimal d3 = 0m;
                    decimal d4 = 0m;
                    tr.info = 0;
                    try
                    {
                        d3 = Decimal.Remainder(d1, d2);
                    }
                    catch (OverflowException e)
                    {
                        tr.info = TestResultInfo.Overflow;
                        Console.WriteLine("{0,2},{1,2} - Remainder error: {2}", i, j, e.Message);
                    }
                    catch (DivideByZeroException e)
                    {
                        tr.info = TestResultInfo.DivideByZero;
                        Console.WriteLine("{0,2},{1,2} - Remainder error: {2}", i, j, e.Message);
                    }

                    if (d3 != Decimal.Zero)
                        try
                        {
                            d4 = d3 + Decimal.Truncate(d1 / d2) * d2;
                            if (d1 != d4)
                            {
                                tr.info = TestResultInfo.ReverseRound;
                                Console.WriteLine("{0,2},{1,2} - Remainder error: reverse rounding error", i, j);
                            }
                        }
                        catch (OverflowException)
                        {
                            tr.info = TestResultInfo.ReverseOverflow;
                            Console.WriteLine("{0,2},{1,2} - Remainder error: reverse overflow", i, j);
                        }

                    tr.val = d3;
                    results[n] = tr;
                }
            }

            WriteResults(tw, "RemResults", results, count, "mod");
            Console.WriteLine();
        }

        static void WriteDivisions(TextWriter tw)
        {
            decimal[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {

                decimal d1 = data[i];
                for (int j = 0; j < count; ++j, ++n)
                {
                    decimal d2 = data[j];
                    decimal d3 = 0m;
                    decimal d4 = 0m;
                    tr.info = TestResultInfo.Ok;
                    try
                    {
                        d3 = Decimal.Divide(d1, d2);
                    }
                    catch (OverflowException e)
                    {
                        tr.info = TestResultInfo.Overflow;
                        Console.WriteLine("{0,2},{1,2} - Div error: {2}", i, j, e.Message);
                    }
                    catch (DivideByZeroException e)
                    {
                        tr.info = TestResultInfo.DivideByZero;
                        Console.WriteLine("{0,2},{1,2} - Div error: {2}", i, j, e.Message);
                    }

                    if (d3 != Decimal.Zero)
                    {
                        try
                        {
                            d4 = d3 * d2;
                            if (d1 != d4)
                            {
                                tr.info = TestResultInfo.ReverseRound;
                                Console.WriteLine("{0,2},{1,2} - DivMult error: reverse rounding error", i, j);
                            }
                        }
                        catch (OverflowException)
                        {
                            tr.info = TestResultInfo.ReverseOverflow;
                            Console.WriteLine("{0,2},{1,2} - DivMult error: reverse overflow", i, j);
                        }
                    }

                    tr.val = d3;
                    results[n] = tr;
                }
            }

            WriteResults(tw, "DivResults", results, count, "/");
            Console.WriteLine();
        }

        static void WriteMultiplications(TextWriter tw)
        {
            decimal[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {

                decimal d1 = data[i];
                for (int j = 0; j < count; ++j, ++n)
                {
                    decimal d2 = data[j];
                    decimal d3 = 0m;
                    decimal d4 = 0m;
                    tr.info = TestResultInfo.Ok;
                    try
                    {
                        d3 = Decimal.Multiply(d1, d2);
                    }
                    catch (OverflowException e)
                    {
                        tr.info = TestResultInfo.Overflow;
                        Console.WriteLine("{0,2},{1,2} - Mult error: {2}", i, j, e.Message);
                    }

                    if (d2 != Decimal.Zero && d3 != Decimal.Zero)
                    {
                        try
                        {
                            d4 = d3 / d2;
                            if (d1 != d4)
                            {
                                tr.info = TestResultInfo.ReverseRound;
                                Console.WriteLine("{0,2},{1,2} - MultDiv error: reverse rounding error", i, j);
                            }
                        }
                        catch (OverflowException)
                        {
                            tr.info = TestResultInfo.ReverseOverflow;
                            Console.WriteLine("{0,2},{1,2} - MultDiv error: reverse overflow", i, j);
                        }
                    }

                    tr.val = d3;
                    results[n] = tr;
                }
            }

            WriteResults(tw, "MultResults", results, count, "*");
            Console.WriteLine();
        }

        static void WriteAdditions(TextWriter tw)
        {
            decimal[] data = testData;
            int count = data.Length;
            TestResult[] results = new TestResult[count * count];
            TestResult tr;

            int n = 0;

            for (int i = 0; i < count; ++i)
            {

                decimal d1 = data[i];
                for (int j = 0; j < count; ++j, ++n)
                {
                    decimal d2 = data[j];
                    decimal d3 = 0m;
                    decimal d4 = 0m;
                    tr.info = TestResultInfo.Ok;
                    try
                    {
                        d3 = Decimal.Add(d1, d2);
                    }
                    catch (OverflowException e)
                    {
                        tr.info = TestResultInfo.Overflow;
                        Console.WriteLine("{0,2},{1,2} - Add error: {2}", i, j, e.Message);
                    }

                    if (d3 != Decimal.Zero)
                    {
                        try
                        {
                            d4 = d3 - d2;
                            if (d1 != d4)
                            {
                                tr.info = TestResultInfo.ReverseRound;
                                Console.WriteLine("{0,2},{1,2} - Subtract error: reverse rounding error", i, j);
                            }
                        }
                        catch (OverflowException)
                        {
                            tr.info = TestResultInfo.ReverseOverflow;
                            Console.WriteLine("{0,2},{1,2} - Subtract error: reverse overflow", i, j);
                        }
                    }

                    tr.val = d3;
                    results[n] = tr;
                }
            }

            WriteResults(tw, "AddResults", results, count, "+");
            Console.WriteLine();
        }

        #region Data
        static decimal[] testData = new decimal[] 
        {
	        0m,                               // 0
	        1m,                               // 1
	        -1m,                              // 2
	        2m,                               // 3
	        10m,                              // 4
	        0.1m,                             // 5
	        79228162514264337593543950335m,   // 6
	        -79228162514264337593543950335m,  // 7
	        27703302467091960609331879.532m,  // 8
	        -3203854.9559968181492513385018m, // 9
	        -48466870444188873796420.028868m, // 10
	        -545193693242804794.30331374676m, // 11
	        0.7629234053338741809892531431m,  // 12
	        -400453059665371395972.33474452m, // 13
	        222851627785191714190050.61676m,  // 14
	        14246043379204153213661335.584m,  // 15
	        -421123.30446308691436596648186m, // 16
	        24463288738299545.200508898642m,  // 17
	        -5323259153836385912697776.001m,  // 18
	        102801066199805834724673169.19m,  // 19
	        7081320760.3793287174700927968m,  // 20
	        415752273939.77704245656837041m,  // 21
	        -6389392489892.6362673670820462m, // 22
	        442346282742915.0596416330681m,   // 23
	        -512833780867323.89020837443764m, // 24
	        608940580690915704.1450897514m,   // 25
	        -42535053313319986966115.037787m, // 26
	        -7808274522591953107485.8812311m, // 27
	        1037807626804273037330059471.7m,  // 28
	        -4997122966.448652425771563042m,  // 29
        };

        static decimal[] compData = new decimal[]
        {
            0m,
            1m,
            -1m,
            2m,
            10m,
            0.1m,
            0.11m,
            0.11000m,
            10.000m,
            -10.000m,
            -10m,
            79228162514264337593543950335m,
            -79228162514264337593543950335m,
            27703302467091960609331879.532m,
            -3203854.9559968181492513385018m,
            -3203854.9559968181492513385017m,
            -48466870444188873796420.0286m,
            -48466870444188873796420.0286000m
        };
        #endregion
    }
}
