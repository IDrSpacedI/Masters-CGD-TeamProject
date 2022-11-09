using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using TMPro;


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

    public void Awake()
    {
        Time.timeScale = 1;
        Cursor.visible = true;
        
    }

    void Update()
    {
        Time.timeScale = 1;
        if (Input.GetKeyDown(KeyCode.Space))
       {
            if (CamerSwticher.IsActiveCamera(rotation))
            {
                CamerSwticher.CamPriority(mainMenus);
                rotation.gameObject.SetActive(false);
            }

       }
    }

    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 120;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 90;


    }
}
