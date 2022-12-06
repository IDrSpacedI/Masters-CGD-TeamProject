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
    public Image Background;
    public GameObject sound;
    public Sprite[] sprites;

    public int x;



    private void Awake()
    {
        Instance = this; // static reference
        allowGameStart = false; // bool set to faluse
    }

  /// <summary>
  /// / hover over to increase font size
  /// </summary>
  /// <param name="txt"></param>
    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 80;


    }

    /// <summary>
    /// shrink text slize back to original
    /// </summary>
    /// <param name="txt"></param>
    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 70;


    }
    /// <summary>
    ///  load  back to main scene
    /// </summary>
    public void LoadScenes()
    {
        StartCoroutine(LoadScene());
        MainLevel = true;
    }

    /// <summary>
    /// load main leve scene
    /// </summary>
    public void MainLoadScenes()
    {
        StartCoroutine(scene_Load());
        PlayerMovement.disableMovement = false;
        Time.timeScale = 1;
        // stop all sound
        SoundManager.instance.StopSound("backgroundForest1");
        SoundManager.instance.StopSound("footStepsGrass");
        SoundManager.instance.StopSound("backgroundForest2");
        SoundManager.instance.StopSound("backgroundForest3");
        SoundManager.instance.StopSound("backgroundForest4");
        SoundManager.instance.StopSound("Music1");
        SoundManager.instance.StopSound("coin");
        SoundManager.instance.StopSound("BackgroundSoft");
        sound.SetActive(false);



        Mainmenu = true;
        
        
    }

    /// <summary>
    /// load scene main game scene with loading screen
    /// </summary>
    /// <returns></returns>
    public IEnumerator LoadScene()
    {

        x = Random.Range(0, 1);
        Background.sprite = sprites[x];
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

    /// <summary>
    /// load scene main game scene with loading screen
    /// </summary>
    /// <returns></returns>
    public IEnumerator scene_Load()
    {
        x = Random.Range(0, 1);
        Background.sprite = sprites[x];
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
            // activate level load
            if (Input.GetKey(KeyCode.Space))
            {
               
                SceneManager.LoadScene("MainLevel1");


            }
        }
        if(Mainmenu == true)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                // activates level loading
                StartCoroutine(delay());
                SceneManager.LoadScene("MainMenu");


            }
        }
        //Debug.Log(allowGameStart);
    }



}


