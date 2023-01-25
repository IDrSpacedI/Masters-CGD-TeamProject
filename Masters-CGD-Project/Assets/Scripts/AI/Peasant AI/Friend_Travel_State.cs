using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.AI;

public class Friend_Travel_State : State
{
	public Friend_Idle_State idleState;
	public Vector3 destination;
	public bool go;
	public NavMeshAgent agent;
	public Animator aiAnimation;

	public override State RunCurrentState()
	{
		if (go)
		{
			agent.SetDestination(destination);
		}
		Vector3 distanceToWalkPoint = transform.position - destination;

		//Destination Reached
		if (distanceToWalkPoint.magnitude < 1f)
		{
			go = false;
			aiAnimation.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
			return idleState;
		}

		aiAnimation.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
		return this;
	}
}
