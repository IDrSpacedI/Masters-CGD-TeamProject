using UnityEngine.Audio;
using UnityEngine;
using UnityEditor;

//alloes sliders and buttons in the inspector
[System.Serializable]
public class Sound
{
    //name of sound for reference when playing
    public string name;

    public AudioClip clip;

    public GameObject audioSource;

	[Range(0f, 1f)]
    public float volume;

	[Range(.1f, 3f)]
    public float pitch;

	[HideInInspector]
    public AudioSource source;

    public bool loop;

    public bool randomArray;

    public AudioClip[] soundsArray;
}

