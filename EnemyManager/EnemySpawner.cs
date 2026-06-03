using Godot;
using System;
using System.Collections.Generic;

public partial class EnemySpawner : Node
{
	Camera2D camera;
	[Export] private PackedScene cop;
	private Godot.RandomNumberGenerator rng = new Godot.RandomNumberGenerator();
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//setup referrences...
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
		while (n != 0)
		{
			float rand_off = rng.RandiRange(0,5);
			Vector2 offset = new Vector2(vis_region.X/2 + rand_off, vis_region.Y/2  + rand_off);
			Vector2 final_pos = offset + camera.GlobalPosition;
			spawnPoints.Add(final_pos);	
			n--;
		}
		return spawnPoints;
	}
	public void Spawn(int w)//WaveGenerator triggers this...
	{
		foreach (var pos in GenerateSpawnPoints(DifficultyScalar(w)))
		{
			CharacterBody2D enemy = cop.Instantiate<CharacterBody2D>();
			enemy.GlobalPosition = pos;
		}
	}
}
