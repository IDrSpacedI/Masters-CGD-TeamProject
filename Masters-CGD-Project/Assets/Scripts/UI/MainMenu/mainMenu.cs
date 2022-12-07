using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using TMPro;
using UnityEngine.SceneManagement;


public class mainMenu : MonoBehaviour
{
    [Header("Cameras")]
    [SerializeField] CinemachineVirtualCamera rotation;
    [SerializeField] CinemachineVirtualCamera mainMenus;



    public void OnEnable()
    {
        // registering all cams
        CamerSwticher.Register(rotation);
        CamerSwticher.Register(mainMenus);
        CamerSwticher.CamPriority(rotation);
    }

    public void OnDisable()
    {
        // un register the cams
        CamerSwticher.UnRegister(rotation);
        CamerSwticher.UnRegister(mainMenus);
    }

    public void Awake()
    {
        // sets curser visible
        Time.timeScale = 1;
        Cursor.visible = true;
        
    }

    void Update()
    {
        // switching round cams
        if (Input.GetKeyDown(KeyCode.Space))
       {
            if (CamerSwticher.IsActiveCamera(rotation))
            {
                CamerSwticher.CamPriority(mainMenus);
                rotation.gameObject.SetActive(false);
            }

       }
    }

    // hover on button to increase or decrease size
    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 120;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 90;


    }
    /// <summary>
    /// loads level based on index
    /// </summary>
    /// <param name="index"></param>
    public void LoadLevel(int index)
    {
        SceneManager.LoadScene(index);

    }

   
}
