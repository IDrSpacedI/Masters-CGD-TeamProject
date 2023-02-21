using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;
using TMPro;

public class LevelLoadingTest : MonoBehaviour
{
    public GameObject Loadscreen;
    public Slider slider;
    public TextMeshProUGUI progressText;

    public Animator flash;

    public int x;

    public string[] tips;
    public Sprite[] sprites;

    public TextMeshProUGUI tipText;
    public Image Background;

    public GameObject mainmenu;

    public void Start()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    public void LoadLevel (int sceneIndex)
    {

        StartCoroutine(LoadAsyncronouly(sceneIndex));
    }

    public IEnumerator LoadAsyncronouly(int sceneIndex)
    {
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneIndex);

        Loadscreen.SetActive(true);
        mainmenu.SetActive(false);
        flash.Play("FlashTransition");
        x = Random.Range(0, 1);
        Background.sprite = sprites[x];
        tipText.text = tips[Random.Range(0, tips.Length)];

        while (!operation.isDone)
        {
            float progress = Mathf.Clamp01(operation.progress / .9f);

            slider.value = progress;
            progressText.text = progress * 100f + "%";

            if(progress == 100)
            {
                flash.Play("FlashTransition");
            }

            Debug.Log(operation.progress);

            yield return null;
        }
    }

    public void OnApplicationQuit()
    {
        Application.Quit();
    }
}
