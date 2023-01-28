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

        Vector3 destinatiuonVector = new Vector3(destination.transform.position.x, transform.position.y, transform.position.z);
        agent.SetDestination(destinatiuonVector);

        Vector3 distanceToPoint = transform.position - destinatiuonVector;

        if(distanceToPoint.magnitude < 1f)
        {
            return B_State;
        }

        return this;

    }

    // not sure if this works. need's some testing. not fun logic xd
}


