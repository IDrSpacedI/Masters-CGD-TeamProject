using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;
// script by Oliver lancashire
// sid 1901981
public class Pause : MonoBehaviour
{
    [Header("Pause Bool")]
    public bool GameIsPaused = false;

    [Header("Game object references")]
    public GameObject pauseMenuUI;
    public GameObject clock;
    [Header("References")]
    public LevelManager manager;

    [Header("Health Reference")]
    public GameObject[] HUDElements;

 
    public void LoadLevel(int index)
    {
        SceneManager.LoadScene(index);
      
    }
    public void Update()
    {
        // pause and un pause function
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
    {//  sets the needed values to true
        pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
        PlayerMovement.disableMovement = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        GameIsPaused = false;

    }

    public void Pause_()
    {
        // sets the values to false
        pauseMenuUI.SetActive(true);
        Time.timeScale = 0f;
        Cursor.visible = true;
        GameIsPaused = true;
        PlayerMovement.disableMovement = true;
        Cursor.lockState = CursorLockMode.None;

    }

    /// <summary>
    /// increases font size
    /// </summary>
    /// <param name="txt"></param>
    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 80;
    }
    // decreases font size
    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 70;
    }
}

    