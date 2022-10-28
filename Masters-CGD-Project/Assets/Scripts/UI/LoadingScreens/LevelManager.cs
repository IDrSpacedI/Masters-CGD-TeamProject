using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

// Script Reference - Scene Manager - Load between scenes and show a progress bar - [ Unity Tutorial ] by Tarodev

public class LevelManager : MonoBehaviour
{
    public static LevelManager instance;

    [SerializeField] private GameObject _LoadScreen;
    [SerializeField] private Image _progressBar;
    private float target;


    public void Awake()
    {
        Time.timeScale = 1;
        Cursor.visible = true;
    }

    public async void LoadScene (string sceneName)
  {
        target = 0;
        _progressBar.fillAmount = 0;
        var scene = SceneManager.LoadSceneAsync(sceneName);
        scene.allowSceneActivation = false;

        _LoadScreen.SetActive(true);

        do
        {
            await Task.Delay(100);
            target = scene.progress;

        } while (scene.progress < 0.9f);

        await Task.Delay(1000);


        scene.allowSceneActivation = true;
        _LoadScreen.SetActive(false);
  }

    public void Update()
    {
        _progressBar.fillAmount = Mathf.MoveTowards(_progressBar.fillAmount, target, 3 * Time.deltaTime);
    }

}
