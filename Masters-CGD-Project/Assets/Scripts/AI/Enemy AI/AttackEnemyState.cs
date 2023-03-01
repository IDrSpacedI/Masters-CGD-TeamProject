using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackEnemyState : State
{
    public GameObject target;
    [SerializeField] private int damage;
    //Create some time between attacks
    public float elapsedTime = 0f;
    [SerializeField] private float TimeAttack;


    [SerializeField] private Animator aiAnimation;
    [SerializeField] private AttackAnimationEnemy attackAnimationEnemy;
    [SerializeField] private ChasePlayerEnemyState chasePlayerEnemyState;

    public override State RunCurrentState()
    {
        //If target is killed
        if (target.GetComponent<HealthManagment>().dead == true)
        {
            target.GetComponent<HealthManagment>().dead = false;
            attackAnimationEnemy.building = false;
            return chasePlayerEnemyState;
        }

        //Attack enemy
        attackAnimationEnemy.building = true;
        aiAnimation.SetBool("attack", true);
        aiAnimation.SetFloat("speed", 0f, 0.1f, Time.deltaTime);
        return this;
    }
    public void Attack()
    {
        //Attack enemy
        target.GetComponent<HealthManagment>().attack(damage);
        FindObjectOfType<SoundManager>().PlaySound("DamageToBuilding");
    }
}
