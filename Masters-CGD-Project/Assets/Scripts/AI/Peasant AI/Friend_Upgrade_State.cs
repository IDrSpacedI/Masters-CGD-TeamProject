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
	public bool added = true;

	private bool returnToIdle;
	IEnumerator WaitCoroutine()
	{
		yield return new WaitForSeconds(0.5f);
	}

	public override State RunCurrentState()
	{
		StartCoroutine(WaitCoroutine());

        if (builder && toolRef.GetComponent<ToolManager>().available && !added)
        {
			added = false;
			toolRef.GetComponent<ToolManager>().potentialUpgrades.Add(this);
        }
        else if (soldier && armRef.GetComponent<ToolManager>().available && !added)
        {
			added = false;
			armRef.GetComponent<ToolManager>().potentialUpgrades.Add(this);
        }
        else if (returnToIdle)
        {
            return idleState;
        }
		return this;
	}

	public void returnToIdleSucesss()
    {
		returnToIdle = true;
    }
	public void returnToIdleFail()
	{
		soldier = false;
		builder = false;
		returnToIdle = true;
	}
}


