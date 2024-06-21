/*
Log.cs
Small library for logging to the console and log file (eventually)

Copyleft (c) 2024 daysant - STRUGGLE & STARS
This file is licensed under the terms of the daysant license.
daysant@proton.me
*/

using Godot;
using System;

public partial class Logger : Node
{
    public int LoggingDetail { get; set; } = 4; // 4 for trace, 3 for debug, 2 for info, and 1 for warn. Errors will always display.

    public void Trace(params object[] text)
    {
        if (LoggingDetail > 3)
        {
            string message = $"\u001b[38;5;8mTRACE | At '{Time.GetTicksMsec()}' in '{GetTree().CurrentScene.SceneFilePath}' | {string.Join(' ', text)}\u001b[38;5;0m";
            Console.WriteLine(message);
        }
    }

    public void Debug(params object[] text)
    {
        if (LoggingDetail > 2)
        {
            string message = $"\u001b[38;5;12m[color=#8888FF]DEBUG | At '{Time.GetTicksMsec()}' in '{GetTree().CurrentScene.SceneFilePath}' | {string.Join(" ", text)}\u001b[38;5;0m";
            Console.WriteLine(message);
        }
    }

    public void Info(params object[] text)
    {
        if (LoggingDetail > 1)
        {
            GD.PrintRich($"\u001b[38;5;15m[color=#FFFFFF]INFO | {string.Join(" ", text)}\u001b[38;5;0m");
        }
    }

    public void Warn(params object[] text)
    {
        if (LoggingDetail > 0)
        {
            string message = $"WARN  | At '{Time.GetTicksMsec()}' in '{GetTree().CurrentScene.SceneFilePath}' | {string.Join(" ", text)}";
            Console.WriteLine($"\u001b[38;5;11m{message}\u001b[38;5;0m");
            GD.PushWarning(message);

            message = $"     | Stack trace:\n{System.Environment.StackTrace}";
            Console.WriteLine($"\u001b[38;5;11m{message}\u001b[38;5;0m");
            GD.PushWarning(message);
        }
    }

    public void Error(params object[] text)
    {
        string message = $"ERROR | At '{Time.GetTicksMsec()}' in '{GetTree().CurrentScene.SceneFilePath}' | {string.Join(" ", text)}";
        Console.WriteLine($"\u001b[38;5;9m{message}\u001b[38;5;0m");
        GD.PushError(message);

        message = $"      | Stack trace:\n{System.Environment.StackTrace}";
        Console.WriteLine($"\u001b[38;5;9m{message}\u001b[38;5;0m");
        GD.PushError(message);
    }
}