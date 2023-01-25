using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoState : State
{
    //public GameObject target;


    public IdleState I_state;
    public BuildState B_State;
    public BuilderManager state;
    public Transform target;
    public bool correct;

    public override State RunCurrentState()
    {
        if (I_state.Move == true)
        {
            //target = Gamemanager.Instance.tower;
            //_target = target.transform;
            return B_State;

        }
        else
        {
            return this;
        }



    }
}

   
