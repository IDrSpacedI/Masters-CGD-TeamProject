using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackTowerStateSoldier : State
{
    public GameObject enemy;
    [SerializeField] private GuardTowerStateSoldier guardTowerStateSoldier;

    public override State RunCurrentState()
    {
        //If enemy dies??? TO BE DISCUSSED 
        if (enemy == null)
            return guardTowerStateSoldier;

        //TODO if not take health from enemy every x seconds 

        return this;
    }

}
