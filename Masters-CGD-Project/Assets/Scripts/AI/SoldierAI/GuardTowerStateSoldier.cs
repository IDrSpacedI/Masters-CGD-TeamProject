using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardTowerStateSoldier : State
{
    [SerializeField] private AttackTowerStateSoldier attackStateSoldier; 
    private GameObject enemy = null;

    public override State RunCurrentState()
    {
        if (enemy != null)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            attackStateSoldier.enemy = enemy;
            return attackStateSoldier;
        }
        return this;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") enemy = other.gameObject;
    }
}
