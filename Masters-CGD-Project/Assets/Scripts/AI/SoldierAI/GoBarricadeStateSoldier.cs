using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


public class GoBarricadeStateSoldier : State
{
    public GameObject barricade;
    public NavMeshAgent navMeshAgent;
    [SerializeField] private Animator aiAnimation;
    [SerializeField] private GuardBarricadeStateSoldier guardBarricadeStateSoldier;
    public override State RunCurrentState()
    {
        //get final destination
        Vector3 barricadePosition = new Vector3(barricade.transform.position.x-1, barricade.transform.position.y, this.transform.position.z);

        if (this.transform.position == barricadePosition)
        {
            //Turn on collision detection
            guardBarricadeStateSoldier.GetComponent<CapsuleCollider>().enabled = true;
            return guardBarricadeStateSoldier;
        }
        aiAnimation.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
        navMeshAgent.destination = barricadePosition;
        return this;
    }
}