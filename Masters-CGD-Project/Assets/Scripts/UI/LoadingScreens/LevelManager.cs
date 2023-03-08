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
    public static LevelManager levelManager;

    public GameObject loadingPanel;

    public int targetScene;

    public Animator mushroom;
    public Animator Loading;

    public float MinLoadTime;
    public Image fade_Image;
    public float fadeTime;

    private bool isLoading;

    private void Awake()
    {

        loadingPanel.SetActive(false);
        fade_Image.gameObject.SetActive(false);
    }


    public void LoadScene(int index)
    {
        targetScene = index;
        StartCoroutine(LoadSceneRoutine());
 
    }
    
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


