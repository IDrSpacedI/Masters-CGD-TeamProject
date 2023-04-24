using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.Rendering;
// script by 1901981
// sid 1901981
// script reference by Brackeys
public class SettingsMenu : MonoBehaviour
{ 
    [Header("Aray")]
    Resolution[] resolutions;
    [Header("UI")]
    public TMP_Dropdown resoluitionDropdown;
    [Header("quality")]
    public RenderPipelineAsset[] qualityAssets;
    public TMP_Dropdown qualityDropdown;

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
    /// updateds where the full screen is true or false
    /// </summary>
    /// <param name="isFullScreen"></param>
    public void setFullScreen(bool isFullScreen)
    {
        Screen.fullScreen = isFullScreen;
    }
    /// <summary>
    /// changes quality level
    /// </summary>
    /// <param name="value"></param>
    public void ChangeLevel(int value)
    {
        QualitySettings.SetQualityLevel(value);
        QualitySettings.renderPipeline = qualityAssets[value];
    }
}


