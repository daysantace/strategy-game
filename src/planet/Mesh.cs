/*
Mesh.cs
Applying meshing stuff for the planet

Copyleft (c) 2024 daysant - STRUGGLE & STARS
This file is licensed under the terms of the Afero GPL v3.0-or-later.
daysant@proton.me
*/

using System;
using System.Runtime.CompilerServices;
using Godot;

public partial class Mesh : Node3D
{
    private int n = 0;
    private Logger logger;
    public override void _Ready()
    {
        logger = new Logger();

        logger.Trace("Trace statement");
        logger.Debug("Debug statement");
        logger.Info("Info statement");
        logger.Warn("Warn statement");
        logger.Error("Error statement");
        // private Texture2D planetTexture = ResourceLoader.Load<Texture2D>("res://planet/planets/earth/terrain.png");
        // private Image heightmap = ResourceLoader.Load<Image>("")
    }
}