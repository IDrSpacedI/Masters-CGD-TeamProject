using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RagdollManager : MonoBehaviour
{
    //get all the rigidbodies from the character model
    Rigidbody[] rigidBodies;
    //reference to the aniamtor
    public Animator animator;

    // Start is called before the first frame update
    void Start()
    {
        //get all the rigidbodies from the character model
        rigidBodies = GetComponentsInChildren<Rigidbody>();
        DeactivateRagdoll();
    }

    // Update is called once per frame
    void Update()
    {
        //used for bugtesting
        //if (Input.GetKey(KeyCode.K))
        //{
        //    ActivateRagdoll();
        //}

        //if (Input.GetKey(KeyCode.L))
        //{
        //    DeactivateRagdoll();
        //}
    }

    //ensure all the rigidbody physics are disabled
    public void DeactivateRagdoll()
    {
        foreach (var rigidBody in rigidBodies)
        {
            rigidBody.isKinematic = true;
        }
        animator.enabled = true;

    }

    //enable all the rigidbodies and physics, disable animator
    public void ActivateRagdoll()
    {
        foreach (var rigidBody in rigidBodies)
        {
            rigidBody.isKinematic = false;
        }
        animator.enabled = false;
    }
}
