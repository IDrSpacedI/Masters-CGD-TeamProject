using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Friend_Init_State : State
{
	public Friend_Idle_State idleState;
	public Friend_Wonder_State wonderState;
	public Friend_Travel_State travelState;

	public override State RunCurrentState()
	{
		idleState.idleTime = 1;
		wonderState.wonderPoint = transform.position;
		wonderState.wonderRange = 5;
		return idleState;
	}
}
