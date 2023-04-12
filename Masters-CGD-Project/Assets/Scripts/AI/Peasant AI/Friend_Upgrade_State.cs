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
	public bool added;

	private bool returnToIdle;
	private ToolManager toolRefM;
	private ToolManager armRefM;
	IEnumerator WaitCoroutine()
	{
		yield return new WaitForSeconds(0.5f);
	}

	public void Start()
	{
		toolRefM = toolRef.GetComponent<ToolManager>();
		armRefM = armRef.GetComponent<ToolManager>();
	}

	public override State RunCurrentState()
	{
		if (returnToIdle)
		{
			return idleState;
		}
		if (builder && toolRefM.available && !added)
		{
			added = toolRefM.AddPeasant(this);
		}
		else if (soldier && armRefM.available && !added)
		{
			Debug.Log("ENTERED SOLDIER");
			added = armRefM.AddPeasant(this);
		}
		return this;
	}

	public bool returnToIdleSucesss()
    {
		return returnToIdle = true;
    }
	public bool returnToIdleFail()
	{
		soldier = false;
		builder = false;
		added = false;
		return returnToIdle = true;
	}
}


