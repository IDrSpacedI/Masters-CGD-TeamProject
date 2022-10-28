using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pause : MonoBehaviour
{
    public bool pause = false;
    public GameObject p_Canvas;
    public GameObject Hud;
    public GameObject InteractiveText;
    public GameObject timer;
    public LevelManager manager;
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (pause)
            {
                Time.timeScale = 1;
                p_Canvas.SetActive(false);
                Hud.SetActive(true);
                timer.SetActive(true);
                InteractiveText.SetActive(true);
                pause = false;
                Cursor.visible = false;

            }
            else
            {
                Time.timeScale = 0;
                p_Canvas.SetActive(true);
                Hud.SetActive(false);
                timer.SetActive(false);
                InteractiveText.SetActive(false);
                pause = true;
                Cursor.visible = true;
            }
        }

        if (Input.GetKeyDown(KeyCode.Q))
        {
            manager.LoadScene("MainMenu");
            p_Canvas.SetActive(false);
            Hud.SetActive(false);
            timer.SetActive(false);
            InteractiveText.SetActive(false);
            Time.timeScale = 1;
            Cursor.visible = true;
        }
    }



    public void Pause_Function()
    {
            Time.timeScale = 1;
            p_Canvas.SetActive(false);
            Hud.SetActive(true);
            pause = false;
            Cursor.visible = false;
    } 

    public void buttontest()
    {
        Debug.Log("button pressed");
    }
}
