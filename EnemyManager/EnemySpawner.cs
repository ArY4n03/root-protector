using Godot;
using System;
using System.Collections.Generic;

public partial class EnemySpawner : Node
{
	Camera2D camera;
	E_StateMachine stateMachine;
	[Export] private PackedScene cop =  GD.Load<PackedScene>("res://EnemyManager/cop_2d.tscn");
	private Godot.RandomNumberGenerator rng = new Godot.RandomNumberGenerator();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//setup referrences...
		camera = GetParent().GetParent().FindChild("Camera2D") as Camera2D;
		stateMachine = GetParent().GetParent().FindChild("EnemyStateMachine") as E_StateMachine;
		//GD.Print("Camera Global Pos : "+camera.GlobalPosition);
	}
	public int DifficultyScalar(int wave_no)
	{
		//Takes in the wave no. and generates the no. of enemies to be spawned GG...
		//linear progression with wave no.
		int amount = 5 * wave_no;
		return amount;
	}
	private List<Vector2> GenerateSpawnPoints(int n)
	{
		//Spawn points should be just outside the visible region
		List<Vector2> spawnPoints = new List<Vector2>();
		Vector2 vis_region = GetViewport().GetVisibleRect().Size;
		float diagonal = (float)Math.Sqrt(vis_region.X * vis_region.X + vis_region.Y * vis_region.Y);
		//GD.Print(vis_region);
		while (n != 0)
		{
			float rand_dir = rng.RandiRange(0, 360);
			Vector2 dir = new Vector2(0,diagonal);
			dir = dir.Normalized();
			dir = dir.Rotated(float.DegreesToRadians(rand_dir));
			Vector2 offset = dir*diagonal;
			Vector2 final_pos = offset + camera.GlobalPosition;
			//GD.Print(final_pos);
			spawnPoints.Add(final_pos);	
			n--;
		}
		return spawnPoints;
	}
	public void Spawn(int w)//WaveGenerator triggers this...
	{
		foreach (var pos in GenerateSpawnPoints(DifficultyScalar(w)))
		{
			if (stateMachine.tail >= stateMachine.max_entity_count ) return ;
			CharacterBody2D enemy = cop.Instantiate<CharacterBody2D>();
			enemy.GlobalPosition = pos;
			AddChild(enemy);
			stateMachine.loginCop(enemy.GetInstanceId());
			//GD.Print(enemy.GlobalPosition);
		}
	}
}
