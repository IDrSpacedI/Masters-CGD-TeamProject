using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IntialState : State
{
	public IdleState idleState;
	public WonderingState wonderState;
	public GoState goState;

	public override State RunCurrentState()
	{
		idleState.idleTime = 1;
		wonderState.wonderPoint = transform.position;
		wonderState.wonderRange = 5;
		return idleState;
	}
}
