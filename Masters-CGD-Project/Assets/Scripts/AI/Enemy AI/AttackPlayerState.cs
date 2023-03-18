using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackPlayerState : State
{
    //Player
    public GameObject player;
    //Damage inflicted
    [SerializeField] private int damage;
    //Create some time between attacks
    public float elapsedTime;
    [SerializeField] private float timeAttack;

    [SerializeField] private Animator aiAnimation;
    [SerializeField] private ChasePlayerEnemyState chasePlayerEnemyState;
    [SerializeField] private AttackAnimationEnemy attackAnimationEnemy;
    public EnemiesInRange enemiesInRange;

    public UnityEngine.AI.NavMeshAgent navMeshAgent;
    private bool isInCooldown = false;

    public override State RunCurrentState()
    {
       //check if player is still in range
       if (!enemiesInRange.playerInRange)
        {
            attackAnimationEnemy.player = false;
            //when the enemy comes back to this state it should be ready to attack
            isInCooldown = true;
            return chasePlayerEnemyState;
        }

        //Play animation
        if(isInCooldown == false)
        {
            attackAnimationEnemy.player = true;
            aiAnimation.SetBool("attack", true);
            aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
            navMeshAgent.destination = player.transform.position;
        }
        else
        {
            aiAnimation.SetFloat("speed", 0f, 0.1f, Time.deltaTime);
            attackAnimationEnemy.player = false;
            elapsedTime += Time.deltaTime;
            if (elapsedTime >= timeAttack)
                isInCooldown = false;
        }
        return this;

    }
    public void Attack()
    {
        //Attack player
        player.GetComponent<IHealth>().reducehealth(damage);
        isInCooldown = true;
        elapsedTime = 0;
    }

}
