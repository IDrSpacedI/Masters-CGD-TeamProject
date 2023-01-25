using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardBarricadeStateSoldier : State
{
    private GameObject enemy = null;
    [SerializeField] private AttackBarricadeSoldierState attackBarricadeSoldierState;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private LightingManager lightingManager;

    public override State RunCurrentState()
    {
        if (enemy != null)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            attackBarricadeSoldierState.enemy = enemy;
            return attackBarricadeSoldierState;
        }

        if (lightingManager.TimeOfDay >= 6)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            return idleStateSoldier;
        }

        return this;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") enemy = other.gameObject;
    }
}
