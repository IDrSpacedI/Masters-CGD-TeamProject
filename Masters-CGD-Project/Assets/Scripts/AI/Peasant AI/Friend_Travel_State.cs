using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.AI;

public class Friend_Travel_State : State
{
	public Friend_Idle_State idleState;
	public Friend_Upgrade_State upgradeState;
	public GameObject toolRef;
	public GameObject armRef;
	public GameObject destination;
	public bool go;
	public bool upgrade;
	public NavMeshAgent agent;
	public Animator aiAnimation;
	private Vector3 desVec;


	public override State RunCurrentState()
	{
		aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
		desVec = new Vector3(destination.transform.position.x, transform.position.y, transform.position.z);
		if (go)
		{
			agent.SetDestination(desVec);
		}
		Vector3 distanceToWalkPoint = transform.position - desVec;

		if (upgrade)
		{
			if((!armRef.GetComponent<ToolManager>().available && destination == armRef) || (!toolRef.GetComponent<ToolManager>().available && destination == toolRef))
			{
				upgrade = false;
				go = false;
				return idleState;
			}
		}

		//Destination Reached
		if (distanceToWalkPoint.magnitude < 1f)
		{
			go = false;
			aiAnimation.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
			if (upgrade)
			{
				return upgradeState;
			}
			return idleState;
		}

		aiAnimation.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
		return this;
	}
}
