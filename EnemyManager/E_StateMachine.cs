using Godot;
using System;
using System.Collections.Generic;

public partial class E_StateMachine : Node
{
	//Get references to all cops 

	public ulong[] copId;
	public CharacterBody2D[] cops;
	private bool[] idle;
	private bool[] move;
	private bool[] attack;
	private bool[] destroy;
	public Dictionary<ulong, int> idindex;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	public void loginCop(ulong id)
	{
		
	}

	public void logoutCop(ulong id)
	{
		
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		
	}

	public void Idle(int idx)
	{
		CharacterBody2D cop = InstanceFromId(copId[idx]) as CharacterBody2D;
		if(cop == null) return;

		if (cop.Velocity.LengthSquared() > 0)
		{
			idle[idx] = false;
			move[idx] = true;
		}
	}

	public void Move(int idx)
	{
		CharacterBody2D cop = InstanceFromId(copId[idx]) as CharacterBody2D;
		if(cop == null) return;
		
		if (cop.Velocity.LengthSquared() == 0)
		{
			idle[idx] = true;
			move[idx] = false;
		}
	}

	public void Mover(int idx)
	{
		//if in moving state , displace them...
		
		//for target calc , loc of player/nearest crop etc
		
		//will move them by velocity 
	}
	
	public void Attack(int idx)
	{
		// if entered area is player attack player
		
		// set other states to false and on attack end go to idle
	}
	
	public void Destroy(int idx)
	{
		// if entered area is crop destroy crop
		
		// set other states to false and on attack end go to idle
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
}
