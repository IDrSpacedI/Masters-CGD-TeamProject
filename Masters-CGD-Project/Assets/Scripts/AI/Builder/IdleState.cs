using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : State
{
    public GoState goState;
    public BuildState BuildState;
    public BuilderManager manager;
    public Animator aiAnimation;
    public float idleTime;
    private float time;
    public WonderingState wonderingState;
    

    public override State RunCurrentState()
    {

        aiAnimation.SetFloat("Speed", 0f, 0.5f, Time.deltaTime);

        foreach (GameObject objects in Gamemanager.Instance.Objects)
        {
            try
            {
                if (objects.GetComponent<BuildInteraction>().Available == true)
                {
                    goState.destination = objects;
                    return goState;
                }

            }
            catch
            {
                if (objects.GetComponent<GetMoney>().Available == true)
                {
                    goState.destination = objects;
                    return goState;
                }
            }


        }
        if (time < idleTime)
        {
            time += Time.deltaTime;
        }
        else
        {
            time = 0;
            return wonderingState;
        }
        return this;

    

    }
}
