using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildState : State
{

    public bool interact;
    public BuilderManager state;
    public GoState goState;
    public IdleState IdleState;


    public override State RunCurrentState()
    {


        goState.destination = Gamemanager.Instance.tower;
        goState.destination.GetComponent<BuildInteraction>().Upgrade();


        return this;

    
    }
}
