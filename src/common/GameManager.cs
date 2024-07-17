/*
GameManager.cs
Management for core system functionality

Copyleft (c) 2024 daysant - STRUGGLE & STARS
This file is licensed under the daysant license.
daysant@proton.me
*/

using Godot;
using System;
using System.Runtime.InteropServices;

public partial class GameManager : Node
{
    private Logger logger;

    [Signal]
    public delegate void TickEventHandler();

    public string player;
    public string planet;

    public override void _Ready()
    {
        logger = GetNode<Logger>("/root/Logger");
        player = "HNGK";  // TEMPORARY 
        planet = "res://src/planet/planets/earth/";

        logger.Info(ProjectSettings.GetSetting("application/config/version").ToString());
    }
}