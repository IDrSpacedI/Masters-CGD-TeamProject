using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildState : State
{
    public GameObject target;

    public override State RunCurrentState()
    {
        target = Gamemanager.Instance.tower;
        target.GetComponent<BuildInteraction>().Upgrade();

        //Return to the Gostate here?
        return this;
    }
}
