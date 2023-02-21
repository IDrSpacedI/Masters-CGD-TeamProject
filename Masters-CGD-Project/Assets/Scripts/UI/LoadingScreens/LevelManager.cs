using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
// scipt by Oliver Lancashire
//sid 1901981
// Script Reference How to make a LOADING BAR in Unity - Brackeys

public class LevelManager : MonoBehaviour
{
    [Header("Reference")]
    public static LevelManager Instance;
    [Header("GameObjects")]
    public GameObject Loadscreen;
    public GameObject PressSpace;
    public GameObject sound;
    public GameObject bar;
    [Header("bools")]
    public bool allowGameStart = false;
    public bool MainLevel;
    public bool Mainmenu;
    [Header("UI")]
    public TextMeshProUGUI tipText;
    public Image Background;
    [Header("Arrays")]
    public string[] tips;
    public Sprite[] sprites;
    [Header("Animators")]
    public Animator P_bar;
    public Animator text;
    [Header("Int")]
    public int x;

    private void Awake()
    {
        Instance = this; // static reference
        allowGameStart = false; // bool set to faluse
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

  /// <summary>
  /// / hover over to increase font size
  /// </summary>
  /// <param name="txt"></param>
    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 75;


    }

    public void LoadLevel(int index)
    {
        SceneManager.LoadScene(index);
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

    public void OnApplicationQuit()
    {
        Application.Quit();
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
    /// <summary>
    /// Loads mainMenu
    /// </summary>
    public void MainMenu()
    {
        StartCoroutine(scene_Load());
        Time.timeScale = 1;
        Mainmenu = true;
    }

    public void Update()
    {
        // checks if bools are true
        if (allowGameStart == true && MainLevel == true)
        {
            // activate level load
            if (Input.GetKey(KeyCode.Space))
            {
               
                SceneManager.LoadScene("MainLevel1");


            }
        }
        // checks is bool is true
        if(Mainmenu == true)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                // activates level loading
          
                SceneManager.LoadScene("MainMenu");


            }
        }
        //Debug.Log(allowGameStart);

       
    }



}


