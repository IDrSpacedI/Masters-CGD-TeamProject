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

    public Animator mainmenuTextAnim;
 
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


    public void buttonHover(int selection)
    {
        mainmenuTextAnim.SetInteger("Selection", selection);
    }

    public void OnApplicationQuit()
    {
        Application.Quit();
    }

    public void setActivefalse(GameObject obj)
    {
        obj.SetActive(false);
    }
    public void setActivetrue(GameObject objs)
    {
        objs.SetActive(true);
    }

}
