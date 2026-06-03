using Godot;
using System;
using System.Collections.Generic;

public partial class CropManager : Node
{
	[Export] int growth_factor = 1;
	
	public ulong[] CropId;
	public int[] Stage;// 1 2 and 3rd is the final stage
	public bool[] Watered;
	public int[] Growth;
	private int tail = 0;
	public Dictionary<ulong, int> idindex;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//Setup references and initialize variables
		CropId =  new ulong[1024];
		Stage = new int[1024];
		Watered = new bool[1024];
		Growth = new int[1024];
		idindex = new Dictionary<ulong, int>();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _PhysicsProcess(double delta)
	{
		grow();
	}

	public void destroy(ulong id,bool player)//called by player or cop
	{
		int idx = idindex[id];
		//if destroyed by cop , no power up drop //else by player , power up drop if growth is 3
		if (player && (Growth[idx] == 3))
		{
			//get location and Spawn powerup
			
		}
		swap_remove(idx, tail);
		tail--;
		//update the dictionary
		idindex.Remove(id);
	}

	public void plant(ulong id)//called by player...
	{
		if (tail >= 1024) return;//Capping max no. of crops
		//update the dictionary
		CropId[tail] = id;
		Stage[tail] = 1;
		Watered[tail] = false;
		Growth[tail] = 0;
		idindex.Add(id, tail);
		tail++;
	}

	public void water(ulong id)//called by player...
	{
		int idx = idindex[id];
		if (Stage[idx] == 3) return;
		Watered[idx] = true;
	}
	
	public void grow()
	{
		for (int i = 0; i < tail; i++)
		{
			int idx = idindex[CropId[i]];
			if (Stage[idx] == 3) return;
			
			if (Watered[idx])
			{
				Growth[idx] += growth_factor;
			}
			if(Growth[idx]>1000)
			{
				Stage[idx]++;
				Watered[idx] = false;
				Growth[idx] = 0;
			}
		}
	}
	private void swap_remove(int idx,int tail)
	{
		(CropId[idx], CropId[tail]) = (CropId[tail], CropId[idx]);
		(Stage[idx], Stage[tail]) = (Stage[tail], Stage[idx]);
		(Watered[idx], Watered[tail]) = (Watered[tail], Watered[idx]);
		(Growth[idx], Growth[tail]) = (Growth[tail], Growth[idx]);
		//----reset tail-----
		CropId[tail] = 0;
		Stage[tail] = 0;
		Watered[tail] = false;
		Growth[tail] = 0;
	}
}
