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

      
            goState.destination.GetComponent<BuildInteraction>().Upgrade();
     

 

        if (goState.destination.GetComponent<BuildInteraction>().finished == true)
        {

            animator.SetFloat("Speed", 0f, 0.5f, Time.deltaTime);
            return IdleState;

          
        }
        else
        {
            return this;
        }

       
    
    }
}
