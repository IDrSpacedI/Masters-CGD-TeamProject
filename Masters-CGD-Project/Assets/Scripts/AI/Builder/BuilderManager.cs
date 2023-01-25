using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class BuilderManager : MonoBehaviour
{
   public State currentState;

    public Transform target;
    public Transform PreviousSpot;
    public float _speed;

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

    public void Moving()
    {
        transform.position = Vector3.MoveTowards(transform.position, target.position, _speed * Time.deltaTime);
    }
    public void MovingBack()
    {
        transform.position = Vector3.MoveTowards(transform.position, PreviousSpot.position, _speed * Time.deltaTime);
       
    }

    // not sure if this works. need's some testing. not fun logic xd
}
