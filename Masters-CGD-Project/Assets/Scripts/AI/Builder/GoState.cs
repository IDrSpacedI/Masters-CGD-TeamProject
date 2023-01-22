using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoState : State
{
    public GameObject target;

    public override State RunCurrentState()
    {
        target = Gamemanager.Instance.tower;

        //Move code here

        return this;
    }
}
