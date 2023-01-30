using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackBarricadeSoldierState : State
{
    public GameObject enemy;
    [SerializeField] private GuardBarricadeStateSoldier guardBarricadeStateSoldier;

    public override State RunCurrentState()
    {
        if (enemy == null)
            return guardBarricadeStateSoldier;

        //TODO if not take health from enemy every x seconds 

        return this;
    }

}
