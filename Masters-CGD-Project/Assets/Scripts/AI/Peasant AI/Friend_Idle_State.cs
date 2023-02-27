using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Friend_Idle_State : State
{
	public Friend_Wonder_State wonderState;
	public Friend_Travel_State travelState;
	public Friend_Upgrade_State upgradeState;
	public GameObject builderPrefab;
	public GameObject soldierPrefab;
	public GameObject peasantRef;
	public GameObject spawnEffect;
	public Hiring hiringScript;
	public GameObject toolRef;
	public GameObject armRef;
	public Animator aiAnimation;
	public float idleTime;
	private float time;

	IEnumerator WaitCoroutine()
	{
		yield return new WaitForSeconds(0.5f);
	}

	public override State RunCurrentState()
	{
		aiAnimation.SetFloat("speed", 0f, 0.5f, Time.deltaTime);
		if (travelState.go)
		{
			wonderState.wonderPoint = new Vector3(travelState.destination.transform.position.x, transform.position.y, transform.position.z);
			return travelState;
		}

		if (hiringScript.hired)
		{
			if (armRef.GetComponent<ToolManager>().available && !upgradeState.soldier && !upgradeState.builder)
			{
				travelState.destination = armRef;
				travelState.go = true;
				travelState.upgrade = true;
				upgradeState.soldier = true;
				return travelState;
			}
			else if (toolRef.GetComponent<ToolManager>().available && !upgradeState.builder && !upgradeState.soldier)
			{
				travelState.destination = toolRef;
				travelState.go = true;
				travelState.upgrade = true;
				upgradeState.builder = true;
				return travelState;
			}

			
			if (upgradeState.soldier)
			{
				Vector3 spawnPoint = transform.position;
				spawnEffect.SetActive(true);
				StartCoroutine(WaitCoroutine());
				Instantiate(soldierPrefab, spawnPoint, Quaternion.identity);
				Destroy(peasantRef);
			}
			else if (upgradeState.builder)
			{
				Vector3 spawnPoint = transform.position;
				spawnEffect.SetActive(true);
				StartCoroutine(WaitCoroutine());
				Instantiate(builderPrefab, spawnPoint, Quaternion.identity);
				Destroy(peasantRef);
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
