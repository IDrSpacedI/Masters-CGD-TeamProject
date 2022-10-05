using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class mainMenu : MonoBehaviour
{
    [SerializeField] CinemachineVirtualCamera rotation;
    [SerializeField] CinemachineVirtualCamera mainMenus;

    public void OnEnable()
    {
        CamerSwticher.Register(rotation);
        CamerSwticher.Register(mainMenus);
        CamerSwticher.CamPriority(rotation);
    }

    public void OnDisable()
    {
        CamerSwticher.UnRegister(rotation);
        CamerSwticher.UnRegister(mainMenus);
    }


    void Update()
    {
       if(Input.GetKeyDown(KeyCode.Space))
       {
            if (CamerSwticher.IsActiveCamera(rotation))
            {
                CamerSwticher.CamPriority(mainMenus);
                rotation.gameObject.SetActive(false);
            }

       }
    }
}
