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
	IEnumerator WaitCoroutine()
	{
		yield return new WaitForSeconds(0.5f);
	}

	public override State RunCurrentState()
	{
		StartCoroutine(WaitCoroutine());

		if (builder && toolRef.GetComponent<ToolManager>().available)
		{
			if (toolRef.GetComponent<ToolManager>().RemoveTools(1))
			{
				return idleState;
			}
			else
			{
				builder = false;
				return idleState;
			}
		}
		else if (soldier && armRef.GetComponent<ToolManager>().available)
		{
			if (armRef.GetComponent<ToolManager>().RemoveTools(1))
			{
				return idleState;
			}
			else
			{
				soldier = false;
				return idleState;
			}
		}
		else
		{
			soldier = false;
			builder = false;
			return idleState;
		}
	}
}


