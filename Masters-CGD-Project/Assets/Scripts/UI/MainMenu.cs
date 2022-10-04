using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class MainMenu : MonoBehaviour
{
    [SerializeField] CinemachineVirtualCamera rotatingCamera;
    [SerializeField] CinemachineVirtualCamera MainMenuCam;

    private void OnEnable()
    {
        CameraSwitcher.Register(rotatingCamera);
        CameraSwitcher.unRegister(MainMenuCam);
        CameraSwitcher.CameraPriority(rotatingCamera);
    }
    private void OnDisable()
    {
        CameraSwitcher.unRegister(rotatingCamera);
        CameraSwitcher.unRegister(MainMenuCam);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        { 
            if (CameraSwitcher.IsActiveCamera(rotatingCamera))
            {
                CameraSwitcher.CameraPriority(MainMenuCam);
                rotatingCamera.gameObject.SetActive(false);
            }
         
        }
    }
}
