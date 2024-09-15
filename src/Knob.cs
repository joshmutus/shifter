using Godot;
using System;

public partial class Knob : Area2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ScreenSize = GetViewportRect().Size;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
			Vector2 velocity = new Vector2(
				Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left"),
				Input.GetActionStrength("move_down") - Input.GetActionStrength("move_up")
			);
			var animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

			if (velocity.Length() > 0)
			{
				velocity = velocity * Speed;
				animatedSprite2D.Play();
			}
			else
			{
				animatedSprite2D.Stop();
			}
			
			Position += velocity * (float)delta;
			//Position = new Vector2(
				//x: Mathf.Clamp(Position.X, 0, ScreenSize.X),
				//y: Mathf.Clamp(Position.Y, 0, ScreenSize.Y)
			//);
	}

	[Export]
	public int Speed { get; set; } = 800; // How fast the player will move (pixels/sec).

	public Vector2 ScreenSize; // Size of the game window.
}
