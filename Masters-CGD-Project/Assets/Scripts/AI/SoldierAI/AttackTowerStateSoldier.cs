using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackTowerStateSoldier : State
{
    public GameObject enemy;
    [SerializeField] private GuardTowerStateSoldier guardTowerStateSoldier;

    //Damage and time between attacks
    [SerializeField] private int damage;
    public float elapsedTime;
    [SerializeField] private float TimeAttack;

    public override State RunCurrentState()
    {
        if (enemy == null)
            return guardTowerStateSoldier;

        if (elapsedTime >= TimeAttack)
        {
            //Attack enemy
            Debug.Log("attack");
            enemy.GetComponent<HealthManagmentNPC>().attack(damage);
            elapsedTime = 0f;
        }

        return this;
    }

}
