using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChasePlayerEnemyState : State
{
    //Player
    private GameObject player;
    //Main script
    public EnemiesInRange enemiesInRange;
    //Target chosen according to the priority list
    public GameObject finalTarget = null;
    //Animation and navmesh
    public UnityEngine.AI.NavMeshAgent navMeshAgent;
    [SerializeField] private Animator aiAnimation;

    [SerializeField] private AttackEnemyState attackEnemyState;
    [SerializeField] private AttackPlayerState attackPlayerState;
    [SerializeField] private AttackNPCState attackNPCState;



    private void Start()
    {
        player = GameObject.FindWithTag("Player");
    }

    public override State RunCurrentState()
    {

        //First check for barricades
        if (enemiesInRange.barricades.Count >= 1)
        {
            finalTarget = enemiesInRange.barricades[0];
            enemiesInRange.barricades.Remove(finalTarget);
            attackEnemyState.target = finalTarget;
            return attackEnemyState;
        }
        //Then check for towers                      Tower is built enough to destroy
        else if (enemiesInRange.towers.Count >= 1 && enemiesInRange.towers[0].GetComponent<BuildInteraction>().currentLevel >= 1)
        {
            finalTarget = enemiesInRange.towers[0];
            enemiesInRange.towers.Remove(enemiesInRange.towers[0]);
            attackEnemyState.target = finalTarget;
            return attackEnemyState;
        }
        //Finally check for friendly AI
        else if(enemiesInRange.AIFriendly.Count >= 1)
        {
            Debug.Log("enter AI");
            finalTarget = enemiesInRange.AIFriendly[0];
            enemiesInRange.AIFriendly.Remove(enemiesInRange.AIFriendly[0]);
            attackNPCState.target = finalTarget;
            Debug.Log(finalTarget);
            return attackNPCState;
        }
        //If player is in range...
        else if(enemiesInRange.playerInRange == true)
        {
            attackPlayerState.player = player;
            return attackPlayerState;
        }

        //Go to tower 
        //aiAnimation.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
        //Debug.Log(player);
        navMeshAgent.destination = player.transform.position;
        return this;
    }


}
