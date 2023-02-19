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

    [SerializeField] private ChasePlayerEnemyState chasePlayerEnemyState;

    public override State RunCurrentState()
    {
        //If target is killed
        if (target.GetComponent<HealthManagment>().dead == true)
        {
            target.GetComponent<HealthManagment>().dead = false;
            return chasePlayerEnemyState;
        }

        elapsedTime += Time.deltaTime;
        //If x seconds passed 
        if (elapsedTime >= TimeAttack)
        {
            //Attack enemy
            target.GetComponent<HealthManagment>().attack(damage);
            FindObjectOfType<SoundManager>().PlaySound("DamageToBuilding");
            elapsedTime = 0f;
        }
        return this;
    }
}
