using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class BuilderManager : MonoBehaviour
{
   public State currentState;


    void Update()
    {
        RunStateMachine();
    }

    private void RunStateMachine()
    {
        State nextState = currentState?.RunCurrentState();

        if(nextState != null)
        {
            // switch to the next state
            switchToTheNextState(nextState);
        }
    }

    private void switchToTheNextState(State nextState)
    {
        currentState = nextState;
    }


}
