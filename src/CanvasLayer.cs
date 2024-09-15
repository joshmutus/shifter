using Godot;
using System;

public partial class CanvasLayer : Godot.CanvasLayer
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var foo = GetNode<Label>("foo");
		foo.Text = "HELLO!";
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
