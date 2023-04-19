using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RagdollManager : MonoBehaviour
{
    //get all the rigidbodies from the character model
    Rigidbody[] rigidBodies;
    Collider[] colliders;

    //public CharacterController controller;
    //reference to the aniamtor
    public Animator animator;

    // Start is called before the first frame update
    void Start()
    {
        //get all the rigidbodies from the character model
        rigidBodies = GetComponentsInChildren<Rigidbody>();


        colliders = GetComponentsInChildren<Collider>();


        //controller = GetComponent(typeof(CharacterController)) as CharacterController;
        //controller.detectCollisions = false;

        GameObject ingoreCollsionSystem = GameObject.FindWithTag("Player");

        //if(ingoreCollsionSystem != null)
        //{
        //    controller = ingoreCollsionSystem.GetComponent<CharacterController>();
        //    controller.detectCollisions = false;
        //}


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

        foreach (var collider in colliders)
        {
            collider.enabled = false;
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

        foreach (var collider in colliders)
        {
            collider.enabled = true;
        }

        animator.enabled = false;
    }
}
