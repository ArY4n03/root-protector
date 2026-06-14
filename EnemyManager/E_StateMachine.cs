using Godot;
using System;
using System.Collections.Generic;

public partial class E_StateMachine : Node
{
	private CropManager cropManager;
	
	[Export] public int max_entity_count = 128;
	[Export] float CopMoveSpeed = 100f;
	
	[Export] private float CopAttackRadius = 20000;//squared...
	//Get references to all cops 
	Camera2D camera;// using camera position as target rn
	public int tail = 0;
	
	public ulong[] copId;
	public CharacterBody2D[] cops;
	private int[] Health;
	private bool[] idle;
	private bool[] move;
	private bool[] attack;
	private bool[] destroy;
	private Node2D[] target;
	public Godot.Collections.Dictionary<ulong, int> idindex;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ini_and_ref();
	}

	public void loginCop(ulong id)//Spawner calls this...
	{
		copId[tail] = id;
		//GD.Print("LOGIN COP ID: " + id + " Tail: " + tail);
		cops[tail]= InstanceFromId(copId[tail]) as CharacterBody2D;
		idle[tail] = true;
		move[tail] = false;
		attack[tail] = false;
		destroy[tail] = false;
		target[tail] = camera;
		idindex.Add(id, tail);
		tail++;
	}

	public void logoutCop(ulong id)//StateMachine does this...
	{
		int idx = idindex[id];
		copId[idx] = 0;
		cops[idx].QueueFree();
		cops[idx] = null;
		idle[idx] = false;
		move[idx] = false;
		attack[idx] = false;
		destroy[idx] = false;
		swap_remove(idx, tail);
		tail--;
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		for (int i = 0; i < cops.Length; i++)
		{
			if (cops[i] is null) return;
			Idle(i);
			Move(i);
			Mover(i);
			Attack(i);
		}
		//GD.Print(idindex);
	}

	public void Idle(int idx)
	{
		if(!idle[idx]) return;
		CharacterBody2D cop = InstanceFromId(copId[idx]) as CharacterBody2D;
		if(cop == null) return;
		if (cop.Velocity.LengthSquared() > 0)
		{
			idle[idx] = false;
			move[idx] = true;
		}
		//Play Idle Animation...
		MeshInstance2D mesh = cops[idx].FindChild("MeshInstance2D") as MeshInstance2D;
		mesh.Modulate = Colors.White; 
	}

	public void set_idle(ulong id)
	{
		int idx = idindex[id];
		attack[idx] = false;
		destroy[idx] = false;
		idle[idx] = true;
	}
	
	public void Move(int idx)
	{
		if(!move[idx]) return;
		CharacterBody2D cop = InstanceFromId(copId[idx]) as CharacterBody2D;
		if(cop == null) return;
		
		if (cop.Velocity.LengthSquared() == 0)
		{
			idle[idx] = true;
			move[idx] = false;
		}
		//Play Move animation...
		MeshInstance2D mesh = cops[idx].FindChild("MeshInstance2D") as MeshInstance2D;
		mesh.Modulate = Colors.Cyan; 
	}

	public void Mover(int idx)
	{
		//if not attacking or destroying keep moving...
		if (attack[idx] || destroy[idx]) return;
		//moving state true
		move[idx] = true;
		
		//for target calc , loc of player/nearest crop etc
		Node2D target = nearest_target(copId[idx]);
		//will move them by velocity 
		//GD.Print("Mover's Target : ",target.GlobalPosition);
		cops[idx].Velocity = (target.GlobalPosition - cops[idx].Position).Normalized() * CopMoveSpeed;
		cops[idx].MoveAndSlide();
	}
	
	public void Attack(int idx)
	{
		//GD.Print("Target Name : "+target[idx].Name);
		if ((cops[idx].GlobalPosition - target[idx].GlobalPosition).LengthSquared() < CopAttackRadius) // if in attack range
		{
			attack[idx] = true;
			move[idx] = false;
			idle[idx] = false;
			
			if (target[idx].Name != "Camera2D")//if target is crop then destroy return form this funcc
			{
				//GD.Print("Crop detected!");
				Destroy(idx);
				return;
			}
			if(target[idx].Name == "Camera2D")
			{
				MeshInstance2D mesh = cops[idx].FindChild("MeshInstance2D") as MeshInstance2D;
				mesh.Modulate = Colors.Red; 
			}
			//go back to idle               // cooldown is to be added
			attack[idx] = false;
			idle[idx] = true;
		}
	}
	
	public void Destroy(int idx)
	{
		// if entered area is crop destroy crop
		attack[idx] = false;
		destroy[idx] = true;
		//Play destroy animation...
		MeshInstance2D mesh = cops[idx].FindChild("MeshInstance2D") as MeshInstance2D;
		mesh.Modulate = Colors.Yellow; 
		
		destroy[idx] = false;
		idle[idx] = true;
	}
	
	
	private void swap_remove(int idx,int tail)
	{
		(copId[idx], copId[tail]) = (copId[tail], copId[idx]);
		(idle[idx], idle[tail]) = (idle[tail], idle[idx]);
		(move[idx], move[tail]) = (move[tail], move[idx]);
		(attack[idx], attack[tail]) = (attack[tail], attack[idx]);
		(destroy[idx], destroy[tail]) = (destroy[tail], destroy[idx]);
		//----reset tail-----
		copId[tail] = 0;
		idle[tail] = false;
		move[tail] = false;
		attack[tail] = false;
		destroy[tail] = false;
	}

	private Node2D nearest_target(ulong id)//Update Target array
	{
		//GD.Print("ID : " + id );
		Vector2 position = cops[idindex[id]].GlobalPosition;
		Node2D tar = camera as Node2D;//for debugging..
		float minDistance = (tar.GlobalPosition - position).LengthSquared();
		foreach (var crop in cropManager.Crop)
		{
			if (crop is null) continue;
			float distance = (crop.GlobalPosition - position).LengthSquared();
			if (minDistance > distance)
			{
				minDistance = distance;
				tar = crop;
				target[idindex[id]] = tar;
			}
			if (minDistance > (camera.GlobalPosition - position).LengthSquared())
			{
				minDistance = distance;
				tar = camera;
				target[idindex[id]] = tar;
			}
		}
		//GD.Print("Target Name : "+tar.Name);
		return tar;
	}

	private void ini_and_ref()
	{
		cropManager =  GetNode<CropManager>("/root/CropManager");
		//Array init..
		  copId = new ulong[max_entity_count];
		  cops = new CharacterBody2D[max_entity_count];
		  idle = new bool[max_entity_count];
		  move = new bool[max_entity_count];
		  attack = new bool[max_entity_count];
		  destroy = new bool[max_entity_count];
		  target = new Node2D[max_entity_count];

		  idindex = new Godot.Collections.Dictionary<ulong, int>();
		//Refs setup..
		camera = GetParent().FindChild("Camera2D") as Camera2D;
	}
}
