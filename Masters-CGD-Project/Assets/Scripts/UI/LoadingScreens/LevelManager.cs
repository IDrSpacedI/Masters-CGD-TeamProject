using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;
// script by Oliver Lancashire
//sid 1901981
// script reference  - https://www.youtube.com/watch?v=XUK4OkqtnBo - skillcap games


public class LevelManager : MonoBehaviour
{
    [Header("stattic references")]
    public static LevelManager levelManager;
    [Header("game object")]
    public GameObject loadingPanel;
    [Header("int")]
    public int targetScene;
    [Header("animations")]
    public Animator mushroom;
    public Animator Loading;
    [Header("floats")]
    public float MinLoadTime;
    public float fadeTime;
    [Header("image")]
    public Image fade_Image;
    [Header("bool")]
    private bool isLoading;

    private void Awake()
    {
        // sets objects
        loadingPanel.SetActive(false);
        fade_Image.gameObject.SetActive(false);
    }

    /// <summary>
    /// load chosen scene
    /// </summary>
    /// <param name="index"></param>
    public void LoadScene(int index)
    {
        targetScene = index;
        StartCoroutine(LoadSceneRoutine());
 
    }
    
    /// <summary>
    /// run method to play animation and include smooth transition between scenes
    /// </summary>
    /// <returns></returns>
    private IEnumerator LoadSceneRoutine()
    {

        isLoading = true;

        fade_Image.gameObject.SetActive(true);
        fade_Image.canvasRenderer.SetAlpha(0);
        while (!Fade(1))
            yield return null;


        loadingPanel.SetActive(true);
        mushroom.Play("Mushroom");
        Loading.Play("Loading");

        while (!Fade(0))
            yield return null;


       AsyncOperation operation = SceneManager.LoadSceneAsync(targetScene);
        float elapsedLoadTime = 0f;
      

        while (!operation.isDone)
        {
            elapsedLoadTime += Time.deltaTime;
            yield return null;
        }

        while(elapsedLoadTime < MinLoadTime)
        {
            elapsedLoadTime += Time.deltaTime;
            yield return null;
        }

        while (!Fade(1))
            yield return null;


        loadingPanel.SetActive(false);

        while (!Fade(0))
            yield return null;

        isLoading = false;
    }

    /// <summary>
    /// function to complete fade transtion
    /// </summary>
    /// <param name="target"></param>
    /// <returns></returns>
    private bool Fade(float target)
    {
        fade_Image.CrossFadeAlpha(target, fadeTime, true);

        if(Mathf.Abs(fade_Image.canvasRenderer.GetAlpha() - target) <= 0.05f)
        {
            fade_Image.canvasRenderer.SetAlpha(target);
            return true;
        }
        return false;
    }


}


