using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;                                                           

public class SettingsMenu : MonoBehaviour
{
    public AudioMixer audioMixer;
    Resolution[] resolutions;

  
    public TMP_Dropdown resoluitionDropdown;

    public void Start()
    {
        resolutions = Screen.resolutions;

        resoluitionDropdown.ClearOptions();

        List<string> options = new List<string>();
        int currentResolutionIndex = 0;

        for(int i = 0; i < resolutions.Length; i++)
        {
            string option = resolutions[i].width + "x" + resolutions[i].height;
            options.Add(option);

            if(resolutions[i].width == Screen.currentResolution.width &&
                resolutions[i].height == Screen.currentResolution.height)
            {
                currentResolutionIndex = i;
            }
        }
        resoluitionDropdown.AddOptions(options);
        resoluitionDropdown.value = currentResolutionIndex;
        resoluitionDropdown.RefreshShownValue();
    }

    public void SetResolution( int resolutionIndex)
    {
        Resolution resolution = resolutions[resolutionIndex];
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreen);
    }
    public void SetVolume(float volume)
    {
        Debug.Log(volume);
        audioMixer.SetFloat("volume", volume);
    }
    public void SetQuality(int qualityIndex)
    {
        QualitySettings.SetQualityLevel(qualityIndex);
    }

    public void setFullScreen(bool isFullScreen)
    {
        Screen.fullScreen = isFullScreen;
    }

    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 120;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 90;


    }

    public void Back()
    {
        SceneManager.LoadScene(0);
    }
}
