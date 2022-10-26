using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pause : MonoBehaviour
{
    public bool pause = false;
    public GameObject p_Canvas;
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (pause)
            {
                Time.timeScale = 1;
                p_Canvas.SetActive(false);
                pause = false;
            }
            else
            {
                Time.timeScale = 0;
                p_Canvas.SetActive(true);
                pause = true;
            }
        }
    }
}
