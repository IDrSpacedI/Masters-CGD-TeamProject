using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : State
{
    public GoState goState;
    public bool Move;
    public BuildState BuildState;
    public BuilderManager manager;

    public override State RunCurrentState()
    {

   
        if (Move)
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

    }
}
