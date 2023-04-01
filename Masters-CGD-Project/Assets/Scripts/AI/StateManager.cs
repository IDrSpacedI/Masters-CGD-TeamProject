using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using UnityEngine;

public class StateManager : MonoBehaviour
{
    public State currentState;
    [SerializeField] private Animator aiAnimation;


    void Update()
    {
        RunStateMachine();

        //if(currentState == )

    }

    private void RunStateMachine()
	{
        State nextState = currentState?.RunCurrentState();

        if (nextState != null)
		{
            currentState = nextState;

        }
        else
        {
            aiAnimation.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
            aiAnimation.SetBool("Attack", false);
        }


    }

    

}
