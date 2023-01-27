using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Friend_Idle_State : State
{
	public Friend_Wonder_State wonderState;
	public Friend_Travel_State travelState;
	public Friend_Upgrade_State upgradeState;
	public Hiring hiringScript;
	public GameObject toolRef;
	public GameObject armRef;
	public Animator aiAnimation;
	public float idleTime;
	private float time;

	public override State RunCurrentState()
	{
		aiAnimation.SetFloat("Speed", 0f, 0.5f, Time.deltaTime);
		if (travelState.go)
		{
			wonderState.wonderPoint = new Vector3(travelState.destination.transform.position.x, transform.position.y, transform.position.z);
			return travelState;
		}

		if (hiringScript.hired)
		{
			if (armRef.GetComponent<ToolManager>().available)
			{
				travelState.destination = armRef;
				travelState.go = true;
				travelState.upgrade = true;
				upgradeState.soldier = true;
				return travelState;
			}

			if (toolRef.GetComponent<ToolManager>().available)
			{
				travelState.destination = toolRef;
				travelState.go = true;
				travelState.upgrade = true;
				upgradeState.builder = true;
				return travelState;
			}
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
