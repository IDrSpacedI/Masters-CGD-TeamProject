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

    public override State RunCurrentState()
    {

        aiAnimation.SetFloat("Speed", 0f, 0.5f, Time.deltaTime);
        if (Gamemanager.Instance.tower != null)
        {
            goState.destination = Gamemanager.Instance.tower;
            return goState;
                       
        }
        if (time < idleTime)
        {
            time += Time.deltaTime;
        }
        else
        {
            time = 0;
            //return wonderState;
        }
        return this;

    

    }
}
