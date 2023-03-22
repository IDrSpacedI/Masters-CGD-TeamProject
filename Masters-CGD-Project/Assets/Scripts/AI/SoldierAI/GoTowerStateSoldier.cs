using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


public class GoTowerStateSoldier : State
{
    public GameObject tower;
    public NavMeshAgent navMeshAgent;
    [SerializeField] private GameObject thisSoldier;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private GuardTowerStateSoldier guardTowerStateSoldier;
    [SerializeField] private Animator aiAnimation;



    public override State RunCurrentState()
    {
        //Check if another soldier stole the spot
        if (tower.GetComponent<LevelWall>().slots.Count == tower.GetComponent<LevelWall>().guards.Count)
        {
            return idleStateSoldier; 
        }
        //Position with the right z
        Vector3 towerPosition = new Vector3(tower.transform.position.x, tower.transform.position.y, this.transform.position.z);
        //Getting distance between the two
        float distance = Vector3.Distance(towerPosition, this.transform.position);
        //If player reached position guard tower
        if (distance <= 0.5)
        {
            //add soldier to tower list
            tower.GetComponent<LevelWall>().guards.Add(thisSoldier);
            thisSoldier.transform.position = tower.GetComponent<LevelWall>().slots[tower.GetComponent<LevelWall>().guards.IndexOf(thisSoldier)].transform.position;
            navMeshAgent.enabled = false;
            //Turn on collision detection
            guardTowerStateSoldier.GetComponent<CapsuleCollider>().enabled = true;
            return guardTowerStateSoldier;
        }

        //Go to tower 
        aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
        navMeshAgent.destination = towerPosition;
        return this;

    }


}
