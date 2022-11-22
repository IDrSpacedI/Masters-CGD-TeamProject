using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Pause : MonoBehaviour {

    public bool GameIsPaused = false;
    public GameObject pauseMenuUI;
    public LevelManager manager;
    public GameObject[] HUDElements;
    public GameObject clock;

    public void Update()
    {
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (GameIsPaused)
            {
                Resume();      
            }
            else
            {
                Pause_();
            }
        }
    }

    public void Resume()
    {
        clock.SetActive(true);
        for (int i = 0; i < HUDElements.Length; i++)
        {
            HUDElements[i].SetActive(true);
        }
        pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
        PlayerMovement.disableMovement = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        GameIsPaused = false;

    }

    public void Pause_()
    {
        for(int i = 0; i< HUDElements.Length; i++)
        {
            HUDElements[i].SetActive(false);
        }
        clock.SetActive(false);
        
        pauseMenuUI.SetActive(true);
        Time.timeScale = 0f;
        Cursor.visible = true;
        GameIsPaused = true;
        PlayerMovement.disableMovement = true;
        Cursor.lockState = CursorLockMode.None;

    }


    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 80;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 70;


    }
}