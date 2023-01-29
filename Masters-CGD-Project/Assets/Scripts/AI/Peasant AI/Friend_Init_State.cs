using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Friend_Init_State : State
{
	public Friend_Idle_State idleState;
	public Friend_Wonder_State wonderState;
	public Friend_Travel_State travelState;
	public Friend_Upgrade_State upgradeState;

	public override State RunCurrentState()
	{
		idleState.idleTime = 1;
		idleState.toolRef = upgradeState.toolRef = travelState.toolRef = GameObject.Find("GameManager").GetComponent<Gamemanager>().toolRef;
		idleState.armRef = upgradeState.armRef = travelState.armRef = GameObject.Find("GameManager").GetComponent<Gamemanager>().armRef;
		wonderState.wonderPoint = transform.position;
		wonderState.wonderRange = 2.5f;
		return idleState;
	}
}
