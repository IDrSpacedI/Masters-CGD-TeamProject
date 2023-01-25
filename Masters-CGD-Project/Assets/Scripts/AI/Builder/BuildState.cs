using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildState : State
{
    //public GameObject target;
    //public BuildInteraction interaction;
    public bool interacts;
    public BuilderManager state;
    public IdleState IdleState;
    public GameObject Position;
    public BuildingInteration interaction;
    public EnterTrigger trigger;
    public bool back;
    public bool build;

    public override State RunCurrentState()
    {
        //if(interacts == true)
        //{
        //      target = Gamemanager.Instance.tower;
        //      target.GetComponent<BuildInteraction>().Upgrade();
        //      Debug.Log("Build");
        //      //Return to the Gostate here?
        //}

        if (interaction.Flagged == true)
        {
            if (Position.transform == Position.transform)
            {
                build = true;
                Debug.Log("Build");

            }
            else
            {
                return IdleState;
                
            }
          
            return this;

        }
        else if(interaction.Flagged == false)
        {
           
            return IdleState;
        }
        else
        {
            return this;
        }
        ////if(interacts == true)
        ////{
        ////    state.MovingBack();
        ////    return IdleState;
        ////}
       
        // not sure if this works. need's some testing. not fun logic xd
    
    }
}
