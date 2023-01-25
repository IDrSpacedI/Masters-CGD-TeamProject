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
        
            //target = Gamemanager.Instance.tower;
            //_target = target.transform;
            Debug.Log("Move");
            return B_State;

    }

    // not sure if this works. need's some testing. not fun logic xd
}


