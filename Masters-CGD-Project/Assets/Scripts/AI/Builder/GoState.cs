using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class GoState : State
{
    //public GameObject target;


    public IdleState I_state;
    public BuildState B_State;
    public BuilderManager state;
    public bool go;
    public NavMeshAgent agent;
    public Animator animator;
    public GameObject destination;


    public override State RunCurrentState()
    {
        try
        {
            if (destination.GetComponent<BuildInteraction>().Available == false)
            {
                return I_state;
            }
        }
        catch
        {
            if (destination.GetComponent<GetMoney>().Available == false)
            {
                return I_state;
            }
        }
      
     

        Vector3 destinationVector = new Vector3(destination.transform.position.x, transform.position.y, transform.position.z);
        agent.SetDestination(destinationVector);

        Vector3 distanceToPoint = transform.position - destinationVector;

        if(distanceToPoint.magnitude < 1f)
        {
            return B_State;
        }

        animator.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
        return this;

    }

    // not sure if this works. need's some testing. not fun logic xd
}


