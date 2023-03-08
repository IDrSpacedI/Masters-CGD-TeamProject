using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChasePlayerEnemyState : State
{
    //Parent object
    public GameObject enemyParent;
    //Day counter script
    private LightingManager lm;
    //Time of day
    private float time;
    //Spawner
    public GameObject home;
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
        lm = GameObject.FindWithTag("GM").GetComponent<LightingManager>();
        time = lm.TimeOfDay;
    }

    public override State RunCurrentState()
    {
        //Get current time
        time = lm.TimeOfDay;
        //Check if night time
        if (!(time > 6f && time < 18f))
        {
            //First check for barricades
            if (enemiesInRange.barricades.Count >= 1 && enemiesInRange.barricades[0].GetComponent<BuildInteraction>().currentLevel == 1)
            {
                finalTarget = enemiesInRange.barricades[0];
                enemiesInRange.barricades.Remove(enemiesInRange.barricades[0]);
                attackEnemyState.target = finalTarget;
                navMeshAgent.destination = this.transform.position;
                return attackEnemyState;
            }
            //Then check for towers                      Tower is built enough to destroy
            else if (enemiesInRange.towers.Count >= 1 && enemiesInRange.towers[0].GetComponent<BuildInteraction>().currentLevel >= 1)
            {
                finalTarget = enemiesInRange.towers[0];
                enemiesInRange.towers.Remove(enemiesInRange.towers[0]);
                attackEnemyState.target = finalTarget;
                navMeshAgent.destination = this.transform.position;
                return attackEnemyState;
            }
            //Finally check for friendly AI
            else if (enemiesInRange.AIFriendly.Count >= 1)
            {
                Debug.Log("enter AI");
                finalTarget = enemiesInRange.AIFriendly[0];
                enemiesInRange.AIFriendly.Remove(enemiesInRange.AIFriendly[0]);
                attackNPCState.target = finalTarget;
                Debug.Log(finalTarget);
                navMeshAgent.destination = this.transform.position;
                return attackNPCState;
            }
            //If player is in range...
            else if (enemiesInRange.playerInRange == true)
            {
                attackPlayerState.player = player;
                navMeshAgent.destination = this.transform.position;
                return attackPlayerState;
            }

            //Go to tower 
            aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
            aiAnimation.SetBool("attack", false);

            //Debug.Log(player);
            navMeshAgent.destination = player.transform.position;

        }
        else
        {
            //if day time
            aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
            aiAnimation.SetBool("attack", false);
            Vector3 desVec = navMeshAgent.destination = home.transform.position;
            Vector3 distanceToWalkPoint = transform.position - desVec;
            if (distanceToWalkPoint.magnitude < 1f)
            {
                Destroy(enemyParent);
            }
        }
        return this;
    }


}
