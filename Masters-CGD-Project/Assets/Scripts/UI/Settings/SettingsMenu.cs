using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;                                                           
// script by 1901981
// sid 1901981
// script reference by Brackeys
public class SettingsMenu : MonoBehaviour
{
    [Header("Audio")]
    public AudioMixer audioMixer;
    [Header("Aray")]
    Resolution[] resolutions;
    [Header("UI")]
    public TMP_Dropdown resoluitionDropdown;

    public void Start()
    {
        resolutions = Screen.resolutions; // sets Resolution

        resoluitionDropdown.ClearOptions(); //clears options

        List<string> options = new List<string>(); // sets list
        int currentResolutionIndex = 0; // sets index
        // loops through array
        for(int i = 0; i < resolutions.Length; i++)
        {
            string option = resolutions[i].width + "x" + resolutions[i].height; // sets options
            options.Add(option); // adds options to string
            // checks is width and height matches with current resolution
            if(resolutions[i].width == Screen.currentResolution.width &&
                resolutions[i].height == Screen.currentResolution.height)
            {
                currentResolutionIndex = i;
            }
        }
        // adds options to dropdown
        resoluitionDropdown.AddOptions(options);
        resoluitionDropdown.value = currentResolutionIndex; // sets value
        resoluitionDropdown.RefreshShownValue(); // refreshes values at start
    }
    /// <summary>
    /// sets resolution based on heigh , width and full screen
    /// </summary>
    /// <param name="resolutionIndex"></param>
    public void SetResolution( int resolutionIndex)
    {
        Resolution resolution = resolutions[resolutionIndex];
        Screen.SetResolution(resolution.width, resolution.height, Screen.fullScreen);
    }
    /// <summary>
    /// sets volume based on the audio mixer
    /// </summary>
    /// <param name="volume"></param>
    public void SetVolume(float volume)
    {
        Debug.Log(volume);
        audioMixer.SetFloat("volume", volume);
    }
    /// <summary>
    /// set quality based on  the index
    /// </summary>
    /// <param name="qualityIndex"></param>
    public void SetQuality(int qualityIndex)
    {
        QualitySettings.SetQualityLevel(qualityIndex);
    }
    /// <summary>
    /// updateds where the full screen is true or false
    /// </summary>
    /// <param name="isFullScreen"></param>
    public void setFullScreen(bool isFullScreen)
    {
        Screen.fullScreen = isFullScreen;
    }

    // hover on button to increase or decrease size

    public void onClickEnter(TextMeshProUGUI txt)
    {
        txt.fontSize = 120;


    }

    public void onClickExit(TextMeshProUGUI txt)
    {
        txt.fontSize = 90;


    }


    // load scene
    public void Back()
    {
        SceneManager.LoadScene(0);
    }
}
