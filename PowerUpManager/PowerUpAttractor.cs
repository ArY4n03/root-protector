using Godot;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public partial class PowerUpAttractor : Node
{
	// ---------------- CONFIG ----------------
	[Export] float pickup_radius = 10f;
	float pickup_radius_sq;
	[Export] float snap_distance = 0.2f;

	
	public CharacterBody2D player;
	public Node container;
	private int total_count = 2048;

	private GodotObject obj;
	// cached each frame
	private Vector2 player_pos;

	private int[] activetime;
	public Vector2[] pos;
	private float[] dist_sq;
	private ulong[] instance_id;
	private bool[] active;//object pooling
	public bool[] bounded;//has come in range ever
	

	public Dictionary<ulong,int> IdIndex;	

	public override void _Ready()
	{
		pickup_radius_sq = pickup_radius * pickup_radius;
		activetime = new int[total_count];
		pos = new Vector2[total_count];
		dist_sq = new float[total_count];
		instance_id = new ulong[total_count];
		active = new bool[total_count];
		bounded = new bool[total_count];
		IdIndex = new Dictionary<ulong,int>();
		//node_to_data();
	}

	public override void _PhysicsProcess(double delta)
	{
		player_pos = player.GlobalPosition;
		update_all((float)delta);
		apply_to_nodes();
	}
	
	public void node_to_data()//Called by pool after filling in the Container...
	{
		int i = 0;
		foreach (Node2D n in container.GetChildren())
		{
			if(n is Node2D p)
			{
				activetime[i] = 0;
				pos[i] = p.GlobalPosition;
				//GD.Print(pos[i]);
				dist_sq[i] = float.MaxValue;
				instance_id[i] = p.GetInstanceId();
				IdIndex.Add(instance_id[i], i);
				//GD.Print(instance_id[i]," ",i);
				i++;
			}
		}
	}
	
private void update_all(float delta)
{
	for (int i = 0; i < total_count; i++)
	{
		if (!active[i]) continue;

		Vector2 toPlayer = player_pos - pos[i];
		//GD.Print(toPlayer);
		float sqrDist = toPlayer.LengthSquared();

		dist_sq[i] = sqrDist;
		
		// Activate magnet behavior
		if (sqrDist <= pickup_radius_sq)
		{	
			//GD.Print("Set b[i] to true GG ");
			activetime[i] += 1;
			bounded[i] = true;
		}
		if (activetime[i] <= 0f) continue;
		float dist = Mathf.Sqrt(sqrDist);
		// Prevent divide-by-zero
		if (dist < 0.001f) continue;
		Vector2 direction = toPlayer / dist;
		float speed = (4.0f) + (25.0f / (dist + 0.15f));
		// MOVE instead of overwrite
		//GD.Print(bounded[i]);
		if(bounded[i]) pos[i] += direction * speed * delta;
		//GD.Print(pos[i]);
	}

}

private void apply_to_nodes()
{
	for (int i = 0; i < total_count; i++)
	{
		if (!active[i]) continue;
		GodotObject obj = GodotObject.InstanceFromId(instance_id[i]);
		if (obj is not Node2D bp) continue;

		if(bounded[i]) bp.GlobalPosition = pos[i];
		//GD.Print(pos[i]);
		// Snap to player

		if (dist_sq[i] < snap_distance)
		{
			//GD.Print("Snapped");
			bp.GlobalPosition = player_pos;
			//bp.pickup_job();//Power Up's job 
			active[i] = false;
			bounded[i] = false;
			dist_sq[i] = float.MaxValue;
			activetime[i] = 0;
			//GD.Print(bounded[i]);
			//Swap and remove index...
		}

	}
}
	public void activate(ulong id)
	{
		int idx = IdIndex[id];
		active[idx] = true;
		bounded[idx] = false;
	}

}
