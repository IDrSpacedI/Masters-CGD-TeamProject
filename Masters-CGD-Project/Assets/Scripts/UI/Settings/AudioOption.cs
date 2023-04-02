using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;

// kap koder - https://www.youtube.com/watch?v=pbuJUaO-wpY&t=107s
public class AudioOption : MonoBehaviour
{
    #region variables
    [Header("Mixer")]
    [SerializeField] AudioMixer mixer; // mixer reference
    [Header("Sliders")]
    [SerializeField] Slider musicSlider; //slider for main track
    [SerializeField] Slider SFX; // sound effects
    [Header("Strings ")]
    public const string MIXER_MUSIC = "MusicVolume"; // music string
   public const string MIXER_SFX = "SFXVoume"; // sft string
    #endregion
    #region awake
    private void Awake()
    {
        musicSlider.onValueChanged.AddListener(setMusicVolume); // add lister
        SFX.onValueChanged.AddListener(setSFXcVolume); // add lister
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
        mixer.SetFloat(MIXER_MUSIC,Mathf.Log10(value) * 20);
    }
    #endregion
    #region set sfx
    /// <summary>
    /// function to change the sound effects
    /// </summary>
    /// <param name="value"></param>
    public void setSFXcVolume(float value)
    {
        mixer.SetFloat(MIXER_SFX, Mathf.Log10(value) * 20);
    }
    #endregion
    #region on disable
    /// <summary>
    /// saving the sliders values
    /// </summary>
    //public void OnDisable()
    //{
    //    PlayerPrefs.SetFloat(Audiomanager.MUSIC_KEY, musicSlider.value);
    //    PlayerPrefs.SetFloat(Audiomanager.SFX_KEY, SFX.value);
    //}
    #endregion
}
