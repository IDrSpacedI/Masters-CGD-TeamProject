using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IInteractable
{   
    //Prompt text
    public string InteractionPrompt { get; }

    //Interacting behaviour (differs with each building)
    public bool Interact(Interactor interactor);
    public void OnEnter();
    public void OnLeave();

}
