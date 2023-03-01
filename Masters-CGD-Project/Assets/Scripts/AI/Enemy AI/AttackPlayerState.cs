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
    [SerializeField] private AttackAnimationEnemy attackAnimationEnemy;
    public EnemiesInRange enemiesInRange;

    public override State RunCurrentState()
    {
       //check if player is still in range
       if (!enemiesInRange.playerInRange)
        {
            attackAnimationEnemy.player = false;
            return chasePlayerEnemyState;
        }

        //Play animation
        attackAnimationEnemy.player = true;
        aiAnimation.SetBool("attack", true);
        aiAnimation.SetFloat("speed", 0f, 0.1f, Time.deltaTime);
        return this;

    }
    public void Attack()
    {
        //Attack player
        player.GetComponent<IHealth>().reducehealth(damage);
    }

}
