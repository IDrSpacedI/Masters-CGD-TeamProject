using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pause : MonoBehaviour {

    public bool GameIsPaused = false;
    public GameObject pauseMenuUI;
    public LevelManager manager;

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
        pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
        PlayerMovement.disableMovement = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        GameIsPaused = false;

    }

    public void Pause_()
    {
        pauseMenuUI.SetActive(true);
        Time.timeScale = 0f;
        Cursor.visible = true;
        GameIsPaused = true;
        PlayerMovement.disableMovement = true;
        Cursor.lockState = CursorLockMode.None;
    }


    public void QuitGame()
    {
        Cursor.lockState = CursorLockMode.None;
        manager.LoadScene("MainMenu");
    }
}