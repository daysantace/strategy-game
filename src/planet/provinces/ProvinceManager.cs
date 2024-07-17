/*
ProvinceManager.cs
Generates and manages provinces

Copyleft (c) daysant 2024 - STRUGGLE & STARS
This file is licensed under the terms of the Affero GPL v3.0-or-later.
daysant@proton.me
*/

using Godot;
using System;

public partial class ProvinceManager : Node
{
    private Logger logger;

    private bool provincesLoaded;
    private string imageSource;
    public override void _Ready()
    {
        provincesLoaded = false;
        imageSource = "";
        logger = GetNode<Logger>("/root/Logger");
        logger.Debug("Success!");
    }
    // TODO read image 


    // TODO parse image into provinces 

    // TODO detect input 
}