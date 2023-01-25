using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.AI;

public class Friend_Wonder_State : State
{

	public Friend_Idle_State idleState;
	public Vector3 wonderPoint;
	public float wonderRange;
	public LayerMask whatIsGround;
	public NavMeshAgent agent;
	public Animator aiAnimation;

	private bool walkPointSet;
	private Vector3 walkPoint;

	public override State RunCurrentState()
	{
		if (walkPointSet)
		{
			agent.SetDestination(walkPoint);
		}
		else
		{
			SetWalkPoint();
		}
		Vector3 distanceToWalkPoint = transform.position - walkPoint;

		//Walkpoint Reached
		if (distanceToWalkPoint.magnitude < 1f)
		{
			walkPointSet = false;
			return idleState;
		}

		aiAnimation.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
		return this;
	}

	private void SetWalkPoint()
	{
		float randomX = Random.Range(-wonderRange, wonderRange);
		walkPoint = new Vector3(wonderPoint.x + randomX, transform.position.y, transform.position.z);
		if (Physics.Raycast(walkPoint, -transform.up, 2f, whatIsGround))
		{
			walkPointSet = true;
		}
	}
}
