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
		if (builder)
		{
			if (toolRef.GetComponent<ToolManager>().available)
			{
				toolRef.GetComponent<ToolManager>().RemoveTools(1);
				//destroy and change
			}
			else
			{
				builder = false;
				return idleState;
			}
		}

		if (soldier)
		{
			if (armRef.GetComponent<ToolManager>().available)
			{
				armRef.GetComponent<ToolManager>().RemoveTools(1);
				//destroy and chage
			}
			else
			{
				soldier = false;
				return idleState;
			}
		}

		return this;
	}
}
