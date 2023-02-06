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


    [SerializeField] private ChasePlayerEnemyState chasePlayerEnemyState;
    public override State RunCurrentState()
    {
        //If target was deleted
        if (target == null)
        {
            return chasePlayerEnemyState;
        }
        elapsedTime += Time.deltaTime;
        //If x seconds passed 
        if (elapsedTime >= TimeAttack)
        {
            //Attack enemy
            target.GetComponent<HealthManagmentNPC>().attack(damage);
            elapsedTime = 0f;
        }
        return this;
    }
}
