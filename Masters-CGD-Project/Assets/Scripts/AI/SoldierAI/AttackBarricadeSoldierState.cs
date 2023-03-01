using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackBarricadeSoldierState : State
{
    public GameObject enemy;
    [SerializeField] private GuardBarricadeStateSoldier guardBarricadeStateSoldier;

    //Damage and time between attacks
    [SerializeField] private int damage;
    public float elapsedTime;
    [SerializeField] private float TimeAttack;
    [SerializeField] private Animator aiAnimation;

    public override State RunCurrentState()
    {
        aiAnimation.SetBool("attack", true);
        if (enemy == null)
        {
            aiAnimation.SetBool("attack", false);
            return guardBarricadeStateSoldier;
        }
        return this;
    }
    public void Attack()
    {
        FindObjectOfType<SoundManager>().PlaySound("AttackNPC");
        enemy.GetComponent<HealthManagmentNPC>().attack(damage);
        elapsedTime = 0f;
    }
}
