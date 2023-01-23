using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Friend_Idle_State : State
{
	public Friend_Wonder_State wonderState;
	public Friend_Travel_State travelState;
	public Animator aiAnimation;
	public float idleTime;
	private float time;

	public override State RunCurrentState()
	{
		aiAnimation.SetFloat("Speed", 0f, 0.5f, Time.deltaTime);
		if (travelState.go)
		{
			wonderState.wonderPoint = travelState.destination;
			return travelState;
		}
		
		if (time < idleTime)
		{
			time += Time.deltaTime;
		}
		else
		{
			time = 0;
			return wonderState;
		}
		return this;
	}
}
