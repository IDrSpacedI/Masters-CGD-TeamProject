using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : State
{
    public GoState goState;
    public bool Move;

    public override State RunCurrentState()
    {
        if(Gamemanager.Instance.tower!= null)
        {
            //switchToTheNextState(GoState);
            Move = true;
            return goState;
            Debug.Log("Change state");
        }
        else
        {
            return this;
            Debug.Log("IdleState");
        }
    }
}
