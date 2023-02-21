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
    [SerializeField] private float TimeAttack;

    [SerializeField] private Animator aiAnimation;


    [SerializeField] private ChasePlayerEnemyState chasePlayerEnemyState;
    public EnemiesInRange enemiesInRange;

    public override State RunCurrentState()
    {
        elapsedTime += Time.deltaTime;
        //If x seconds passed 
        if (elapsedTime >= TimeAttack)
        {
            if (!enemiesInRange.playerInRange)
            {
                return chasePlayerEnemyState;
            }
            //Attack player
            player.GetComponent<IHealth>().reducehealth(damage);
            elapsedTime = 0f;
        }

        aiAnimation.SetBool("Attack", true);
        aiAnimation.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
        return this;

    }
}
