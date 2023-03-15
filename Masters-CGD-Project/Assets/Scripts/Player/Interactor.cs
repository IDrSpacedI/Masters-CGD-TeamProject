using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interactor : MonoBehaviour
{
    [SerializeField] private Transform interactablePoint;
    [SerializeField] private float radius = 0.5f;
    [SerializeField] private LayerMask interactableMask;
    [SerializeField] private InteractionPromptUI InteractionPromptUI;

    private readonly Collider[] colliders = new Collider[1];
    public int numInteractables;

    private IInteractable interactable;
    public GameObject collidedobject;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //getting the interactable in range and adding it to the colliders list
        numInteractables = Physics.OverlapSphereNonAlloc(interactablePoint.position, radius, colliders, interactableMask);
        if (numInteractables == 1)
        {
           // interactable = colliders[0].GetComponent<IInteractable>();
            interactable = collidedobject.GetComponent<IInteractable>();

            if (interactable != null)
            {
                //Displays the prompt if it's not being displayed
                //if (!InteractionPromptUI.isDisplayed)
                //    InteractionPromptUI.startPrompt(interactable.InteractionPrompt);
                //Calls interactable if E is pressed
                if (Input.GetKeyDown(KeyCode.E))
                    interactable.Interact(this);
            }
        }
        else
        {
            //If there is no interactable in range, set interactable to null
            if (interactable != null)
                interactable = null;
            //Turn off display if no interactable in range
            if (InteractionPromptUI.isDisplayed)
                InteractionPromptUI.closePrompt();

        }

    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(interactablePoint.position, radius);
    }
}
