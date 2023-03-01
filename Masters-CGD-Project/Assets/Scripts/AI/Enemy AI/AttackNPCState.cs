using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackNPCState : State
{
    public GameObject target;
    //Damage inflicted
    [SerializeField] private int damage;
    //Create some time between attacks
    public float elapsedTime;
    [SerializeField] private float TimeAttack;
    public EnemiesInRange enemiesInRange;

    [SerializeField] private Animator aiAnimation;
    [SerializeField] private AttackAnimationEnemy attackAnimationEnemy;
    [SerializeField] private ChasePlayerEnemyState chasePlayerEnemyState;
    public override State RunCurrentState()
    {
        //If target was deleted
        if (target == null)
        {
            attackAnimationEnemy.npc = false;
            return chasePlayerEnemyState;
        }

        attackAnimationEnemy.npc = true;
        aiAnimation.SetBool("attack", true);
        aiAnimation.SetFloat("speed", 0f, 0.1f, Time.deltaTime);
        return this;
    }

    public void Attack()
    {
        //Attack enemy
        target.GetComponent<HealthManagmentNPC>().attack(damage);
    }
}
