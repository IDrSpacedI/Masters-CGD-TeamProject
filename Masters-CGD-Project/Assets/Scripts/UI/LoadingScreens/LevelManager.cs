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
    public GameObject loadScreen;
    public Slider slider;
    public TextMeshProUGUI percent;
    public static LevelManager instance;
    public int scene_Dex;
    public GameObject txtTips;

    public void Awake()
    {
        Cursor.lockState = CursorLockMode.None;
        instance = this;
    }

    public void Update()
    {
        if(scene_Dex == 1)
        {
            txtTips.SetActive(true);
        }
    }
    public void LoadLevel(int sceneIndex)
    {

        StartCoroutine(LoadAsynchronously(sceneIndex));
        scene_Dex = sceneIndex;

    }

    public IEnumerator LoadAsynchronously(int sceneIndex)
    {
        AsyncOperation operation = SceneManager.LoadSceneAsync(sceneIndex);

     
        loadScreen.SetActive(true);

        while (!operation.isDone)
        {
            float progress = Mathf.Clamp01(operation.progress / .9f);

            slider.value = progress;
            percent.text = progress * 100f + "%";

            yield return null;
        }
    }

}
