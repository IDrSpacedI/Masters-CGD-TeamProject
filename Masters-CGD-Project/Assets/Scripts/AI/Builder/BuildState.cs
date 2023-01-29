using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildState : State
{

    public BuilderManager state;
    public GoState goState;
    public IdleState IdleState;
    public IntialState intial;
    public bool ReturnState;
    public Animator animator;


    public override State RunCurrentState()
    {
        goState.destination.GetComponent<BuildInteraction>().Upgrade();
        goState.destination.GetComponent<BuildInteraction>().Available = false;

        if (goState.destination.GetComponent<BuildInteraction>().finished == true)
        {
            return IdleState;
        }

        return this;
    }
}
