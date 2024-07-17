/*
Logger.cs
Small library for logging to the console and log file (eventually)

Copyleft (c) 2024 daysant - STRUGGLE & STARS
This file is licensed under the terms of the daysant license.
daysant@proton.me
*/

using Godot;
using System;

public partial class Logger : Node
{
    public static int LoggingDetail = 4; // 4 for trace, 3 for debug, 2 for info, and 1 for warn. Errors and fatals will always display.

    public void Trace(string text)
    {
        if (LoggingDetail > 3)
        {
            string message = $"\u001b[38;5;8mTRACE | At '{(float)Time.GetTicksMsec()/1000}' in '{GetTree().CurrentScene.SceneFilePath}' | {text}\u001b[38;5;0m";
            Console.WriteLine(message);
        }
    }

    public void Debug(string text)
    {
        if (LoggingDetail > 2)
        {
            string message = $"\u001b[38;5;12mDEBUG | At '{(float)Time.GetTicksMsec()/1000}' in '{GetTree().CurrentScene.SceneFilePath}' | {text}\u001b[38;5;0m";
            Console.WriteLine(message);
        }
    }

    public void Info(string text)
    {
        if (LoggingDetail > 1)
        {
            Console.WriteLine($"INFO  | {text}");
        }
    }

    public void Warn(string text, Exception e = null)
    {
        if (LoggingDetail > 0)
        {
            string exceptionMessage;

            if (e == null)
            {
                exceptionMessage = "Unknown exception";
            }
            else
            {
                exceptionMessage = e.Message;
            }

            string message = $"WARN  | At '{(float)Time.GetTicksMsec()/1000}' in '{GetTree().CurrentScene.SceneFilePath}' | {text}";
            Console.WriteLine($"\u001b[38;5;11m{message}\u001b[0m");
            Console.WriteLine($"\u001b[38;5;11m      | {exceptionMessage}]");

            string stackTrace = System.Environment.StackTrace;
            
            // so the colours can appear in the terminal
            foreach (string line in stackTrace.Split(new[] { System.Environment.NewLine }, StringSplitOptions.None))
            {
                Console.WriteLine($"\u001b[38;5;11m      | {line}\u001b[38;5;9m");
            }
        }
    }

    public void Error(string text, Exception e = null)
    {
        string exceptionMessage;

        if (e == null)
        {
            exceptionMessage = "Unknown exception";
        }
        else
        {
            exceptionMessage = e.Message;
        }

        string message = $"ERROR | At '{(float)Time.GetTicksMsec()/1000}' in '{GetTree().CurrentScene.SceneFilePath}' | {text}";
        Console.WriteLine($"\u001b[38;5;9m{message}\u001b[0m");
        Console.WriteLine($"\u001b[38;5;9m      | {exceptionMessage}]");

        string stackTrace = System.Environment.StackTrace;
        
        foreach (string line in stackTrace.Split(new[] { System.Environment.NewLine }, StringSplitOptions.None))
        {
            Console.WriteLine($"\u001b[38;5;9m      | {line}\u001b[38;5;9m");
        }
    }
}