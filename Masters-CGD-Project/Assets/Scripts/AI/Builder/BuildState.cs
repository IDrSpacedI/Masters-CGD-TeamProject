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
        try {
            animator.SetBool("building", true);
            animator.SetFloat("speed", 0f, 0.1f, Time.deltaTime);

            goState.destination.GetComponent<BuildInteraction>().Upgrade();
            goState.destination.GetComponent<BuildInteraction>().Available = false;
            if (goState.destination.GetComponent<BuildInteraction>().finished == true)
            {
                return IdleState;
            }
        }
        catch
        {/*
            goState.destination.GetComponent<GetMoney>().gameObject.SetActive(false);
            goState.destination.GetComponent<GetMoney>().Available = false;
            return IdleState;*/
        }
        
        return this;
    }
}
