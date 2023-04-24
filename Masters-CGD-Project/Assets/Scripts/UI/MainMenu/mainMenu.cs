using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;
using TMPro;
using UnityEngine.SceneManagement;
// script by Oliver Lancashire
// sid 1901981

public class mainMenu : MonoBehaviour
{ 
    public void Awake()
    {
        // sets curser visible
        Time.timeScale = 1;
        Cursor.visible = true;
        
    }


    // hover on button to increase or decrease size
    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 90;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 85;


    }
    /// <summary>
    /// loads level based on index
    /// </summary>
    /// <param name="index"></param>
    public void LoadLevel(int index)
    {
        SceneManager.LoadScene(index);

    }

    /// <summary>
    /// quit function
    /// </summary>
    public void OnApplicationQuit()
    {
        Application.Quit();
    }

    /// <summary>
    /// sets object to false
    /// </summary>
    /// <param name="obj"></param>
    public void setActivefalse(GameObject obj)
    {
        obj.SetActive(false);
    }
    /// <summary>
    /// sets object to true
    /// </summary>
    /// <param name="objs"></param>
    public void setActivetrue(GameObject objs)
    {
        objs.SetActive(true);
    }

}
