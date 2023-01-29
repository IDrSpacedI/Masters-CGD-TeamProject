using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Friend_Upgrade_State : State
{

	public Friend_Idle_State idleState;
	public GameObject toolRef;
	public bool builder;
	public GameObject armRef;
	public bool soldier;

	public override State RunCurrentState()
	{
		if (builder && toolRef.GetComponent<ToolManager>().available)
		{
			toolRef.GetComponent<ToolManager>().RemoveTools(1);
			return idleState;
		}
		else if (soldier && armRef.GetComponent<ToolManager>().available)
		{
			armRef.GetComponent<ToolManager>().RemoveTools(1);
			return idleState;
		}
		else
		{
			return idleState;
		}
	}
}
