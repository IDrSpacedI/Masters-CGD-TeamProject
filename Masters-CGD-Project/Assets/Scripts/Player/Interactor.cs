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
    private IInteractable oldInteractable;
    public GameObject collidedobject;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //getting the interactables in range and adding it to the colliders list
        numInteractables = Physics.OverlapSphereNonAlloc(interactablePoint.position, radius, colliders, interactableMask);
        if (numInteractables >= 1)
        {
            //choosing the first one in the range
            interactable = colliders[0].GetComponent<IInteractable>();
          
            if (interactable != oldInteractable || oldInteractable == null)
            {
                interactable.OnEnter();
                try
                {
                    oldInteractable.OnLeave();
                }
                catch
                {

                }
            }
            
            //interactable = collidedobject.GetComponent<IInteractable>();

            if (interactable != null)
            {
                //Displays the prompt if it's not being displayed
                //if (!InteractionPromptUI.isDisplayed)
                //    InteractionPromptUI.startPrompt(interactable.InteractionPrompt);
                //Calls interactable if E is pressed
                if (Input.GetKeyDown(KeyCode.E))
                    interactable.Interact(this);
            }
            oldInteractable = interactable;
        }
        else
        {
            //set interactables to null and call the on leave function;
            try
            {
                oldInteractable.OnLeave();
            }
            catch
            {

            }
            interactable = null;
            oldInteractable = null;


        }

    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.blue;
        Gizmos.DrawWireSphere(interactablePoint.position, radius);
    }
}
