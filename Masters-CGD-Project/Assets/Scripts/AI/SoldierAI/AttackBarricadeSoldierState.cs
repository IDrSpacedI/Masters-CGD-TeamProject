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

    public override State RunCurrentState()
    {
        if (enemy == null)
            return guardBarricadeStateSoldier;

        if (elapsedTime >= TimeAttack)
        {
            //Attack enemy
            Debug.Log("attack");
            FindObjectOfType<SoundManager>().PlaySound("AttackNPC");
            enemy.GetComponent<HealthManagmentNPC>().attack(damage);
            elapsedTime = 0f;
        }
        return this;
    }

}
