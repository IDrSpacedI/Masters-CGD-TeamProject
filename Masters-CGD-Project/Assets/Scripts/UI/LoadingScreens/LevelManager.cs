using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

// Script Reference - Scene Manager - Load between scenes and show a progress bar - [ Unity Tutorial ] by Tarodev

public class LevelManager : MonoBehaviour
{
    public static LevelManager instance;

    [SerializeField] private GameObject _LoadScreen;
    [SerializeField] private Image _progressBar;     

    private void Awake()
    {
        if(instance == null)
        {
            instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

  public async void LoadScene(string sceneName)
  {
        var scene = SceneManager.LoadSceneAsync(sceneName);
        scene.allowSceneActivation = false;

        _LoadScreen.SetActive(true);

        do
        {

            _progressBar.fillAmount = scene.progress;

        } while (scene.progress < 0.9f);

        scene.allowSceneActivation = true;
        _LoadScreen.SetActive(false);
  }
}
