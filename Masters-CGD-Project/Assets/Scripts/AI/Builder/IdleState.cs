using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : State
{
    public GoState goState;
    public bool Move;
    public BuildState BuildState;
    public BuilderManager manager;
     public BuildingInteration interation;

    public override State RunCurrentState()
    {

        if (interation.Flagged == true)
        {
            return goState;

        }
        else
        {
            return this;
        }

        //if (Gamemanager.Instance.tower != null)
        //{

        //    Move = true;
        //    return goState;
        //    Debug.Log("Change state");
        //}
        //else
        //{
        //    return this;
        //    Debug.Log("IdleState");
        //}

        // not sure if this works. need's some testing. not fun logic xd

    }
}
