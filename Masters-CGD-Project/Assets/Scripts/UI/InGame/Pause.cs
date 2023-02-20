using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.Profiling;
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
    public GameObject HUDElements;
    public GameObject UIBlur;
    public Animator Pause_Anim;


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

        StartCoroutine(UnPaused());
        PlayerMovement.disableMovement = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        GameIsPaused = false;

    }

    public void Pause_()
    {
        StartCoroutine(Paused());
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

    public IEnumerator Paused()
    {
        pauseMenuUI.SetActive(true);
        Pause_Anim.Play("Pause");
        yield return new WaitForSeconds(3f);
        HUDElements.SetActive(false);
        Time.timeScale = 0f;
    }

    public IEnumerator UnPaused()
    {
        Time.timeScale = 1f;
        UIBlur.SetActive(false);
        Pause_Anim.Play("Unpause");
        yield return new WaitForSeconds(3f);
        pauseMenuUI.SetActive(false);
        HUDElements.SetActive(true);
        clock.SetActive(true);


    }
}

    