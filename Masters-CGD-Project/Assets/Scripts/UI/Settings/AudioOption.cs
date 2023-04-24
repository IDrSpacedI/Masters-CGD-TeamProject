using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

// script by Oliver Lancashire
// sid 1901981

// kap koder - https://www.youtube.com/watch?v=pbuJUaO-wpY&t=107s
public class AudioOption : MonoBehaviour
{
    #region variables
    [Header("Mixer")]
    [SerializeField] AudioMixer mixer; // mixer reference
    [Header("Sliders")]
    [SerializeField] Slider musicSlider; //slider for main track
    [SerializeField] Slider SFX; // sound effects
    [SerializeField] Slider Master; // sound effects
    [Header("Strings ")]
    public const string MusicVolume = "MusicVoume"; // music string
   public const string MasterVolume = "MasterVolume"; // sft string
    public const string SFXVolume = "SFXVolume"; // sft string

    #endregion
    #region awake
    private void Awake()
    {
        musicSlider.onValueChanged.AddListener(setMusicVolume); // add lister
        SFX.onValueChanged.AddListener(setSFXcVolume); // add lister
        Master.onValueChanged.AddListener(setMastercVolume); // add lister
    }
    #endregion

    #region start
    public void Start()
    {
        //musicSlider.value = PlayerPrefs.GetFloat(Audiomanager.MUSIC_KEY, 1f); //load sound
        //SFX.value = PlayerPrefs.GetFloat(Audiomanager.SFX_KEY, 1f); // load sound effects
    }
    #endregion
    #region set music volume
    /// <summary>
    /// function yo change the main music volume
    /// </summary>
    /// <param name="value"></param>
    public void setMusicVolume(float value)
    {
        mixer.SetFloat(MusicVolume, Mathf.Log10(value) * 20);
    }
    #endregion
    #region set sfx
    /// <summary>
    /// function to change the sound effects
    /// </summary>
    /// <param name="value"></param>
    public void setSFXcVolume(float value)
    {
        mixer.SetFloat(SFXVolume, Mathf.Log10(value) * 20);
    }
    public void setMastercVolume(float value)
    {
        mixer.SetFloat(MasterVolume, Mathf.Log10(value) * 20);
    }
    #endregion
 
}
