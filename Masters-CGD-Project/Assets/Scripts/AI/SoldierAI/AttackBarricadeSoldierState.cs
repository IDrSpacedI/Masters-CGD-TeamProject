using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackBarricadeSoldierState : State
{
    public GameObject enemy;
    public bool idle = false;

    [SerializeField] private int damage;

    [SerializeField] private Animator aiAnimation;

    [SerializeField] private GuardBarricadeStateSoldier guardBarricadeStateSoldier;
    [SerializeField] private IdleStateSoldier idleStateSoldier;

    public override State RunCurrentState()
    {
        aiAnimation.SetBool("attack", true);
        if (enemy == null)
        {
            aiAnimation.SetBool("attack", false);
            if (idle == true)
            {
                idle = false;
                return idleStateSoldier;
            }
            return guardBarricadeStateSoldier;
        }
        return this;
    }
    public void Attack()
    {
        FindObjectOfType<SoundManager>().PlaySound("AttackNPC");
        enemy.GetComponent<HealthManagmentNPC>().attack(damage);
    }
}
