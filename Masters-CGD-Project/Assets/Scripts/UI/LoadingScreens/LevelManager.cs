using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

// Script Reference How to make a LOADING BAR in Unity - Brackeys

public class LevelManager : MonoBehaviour
{
    public static LevelManager Instance;
    public GameObject Loadscreen;
    public GameObject PressSpace;
    public Animator text;
    public GameObject bar;
    public bool allowGameStart = false;
    public Animator flash;
    public string[] tips;
    public TextMeshProUGUI tipText;
    public bool MainLevel;
    public bool Mainmenu;
    public Animator P_bar;



    private void Awake()
    {
        Instance = this;
        allowGameStart = false;
    }

  
    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 80;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 70;


    }

    public void LoadScenes()
    {
        StartCoroutine(LoadScene());
        MainLevel = true;
    }
    public void MainLoadScenes()
    {
        StartCoroutine(scene_Load());
        PlayerMovement.disableMovement = false;
        Time.timeScale = 1;
        SoundManager.instance.StopSound("backgroundForest1");
        SoundManager.instance.StopSound("footStepsGrass");
        SoundManager.instance.StopSound("backgroundForest2");
        SoundManager.instance.StopSound("backgroundForest3");
        SoundManager.instance.StopSound("backgroundForest4");
        SoundManager.instance.StopSound("Music1");
        SoundManager.instance.StopSound("coin");
        Mainmenu = true;
        
        
    }

    public IEnumerator LoadScene()
    {

        Loadscreen.SetActive(true);
        P_bar.Play("Progress");
        tipText.text = tips[Random.Range(0, tips.Length)];
        yield return new WaitForSeconds(12f);
        allowGameStart = true;
        bar.SetActive(false);
        tipText.gameObject.SetActive(false);
        PressSpace.SetActive(true);
        text.Play("SpaceBar");
        allowGameStart = true;
    }


    public IEnumerator scene_Load()
    {

        Loadscreen.SetActive(true);
        P_bar.Play("Progress");
        tipText.text = tips[Random.Range(0, tips.Length)];
        yield return new WaitForSeconds(12f);
        bar.SetActive(false);
        tipText.gameObject.SetActive(false);
        PressSpace.SetActive(true);
        text.Play("SpaceBar");
    }


    public IEnumerator delay()
    {
        flash.Play("FlashTransition");
        yield return new WaitForSeconds(4f);
    }
  
    public void Update()
    {

        if (allowGameStart == true && MainLevel == true)
        {
            if (Input.GetKey(KeyCode.Space))
            {
               
                SceneManager.LoadScene("MainLevel1");


            }
        }
        if(Mainmenu == true)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                StartCoroutine(delay());
                SceneManager.LoadScene("MainMenu");


            }
        }
        Debug.Log(allowGameStart);
    }



}


