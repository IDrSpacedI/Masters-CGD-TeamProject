using UnityEngine.Audio;
using UnityEngine;
using UnityEditor;

//alloes sliders and buttons in the inspector
[System.Serializable]
public class Sound
{
    public bool active;
    //name of sound for reference when playing
    public string name;

    public AudioClip clip;

    public GameObject audioSource;

    public bool spactialSound;

    public float minDistance;
    public float maxDistance;

	[Range(0f, 1f)]
    public float volume;

	[Range(.1f, 3f)]
    public float pitch;

	[HideInInspector]
    public AudioSource source;

    public bool loop;

    public bool randomArray;

    public AudioClip[] soundsArray;

    public AudioMixerGroup audioType;

    public bool playOnStart;

    public bool fadeIn;
    [Range(.01f, 3f)]
    public float fadeInTime;

    public bool fadeOut;
    [Range(.01f, 3f)]
    public float fadeOutTime;
}

