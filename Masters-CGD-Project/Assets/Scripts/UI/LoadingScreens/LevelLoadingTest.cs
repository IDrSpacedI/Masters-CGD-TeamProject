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

    public int x;

    public string[] tips;
    public Sprite[] sprites;

    public TextMeshProUGUI tipText;
    public Image Background;

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
        x = Random.Range(0, 1);
        Background.sprite = sprites[x];

        while (!operation.isDone)
        {
            float progress = Mathf.Clamp01(operation.progress / .9f);

            slider.value = progress;
            progressText.text = progress * 100f + "%";

            Debug.Log(operation.progress);

            yield return null;
        }
    }

    public void OnApplicationQuit()
    {
        Application.Quit();
    }
}
