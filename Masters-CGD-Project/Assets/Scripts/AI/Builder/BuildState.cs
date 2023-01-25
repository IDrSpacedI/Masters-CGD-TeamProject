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
          if(Position.transform == Position.transform)
          {
                if (trigger.AI != null)
                {
                    Debug.Log("Build");
                    return this;
                }
                else if (trigger.AI == null)
                {
                    back = true;
                    return IdleState;
                }
                
          }
            return this;
        }
        else if(interaction.Flagged == false)
        {
            state.MovingBack();
            return IdleState;
        }
        else
        {
            return this;
        }
        //if(interacts == true)
        //{
        //    state.MovingBack();
        //    return IdleState;
        //}
       

    
    }
}
