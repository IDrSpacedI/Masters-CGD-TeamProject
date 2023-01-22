using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : State
{
    public GoState goState;

    public override State RunCurrentState()
    {
        if(Gamemanager.Instance.tower!= null)
        {
            //switchToTheNextState(GoState);
            return goState;
        }
        else
        {
            return this;
        }
    }
}
