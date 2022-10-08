using UnityEngine.Audio;
using System;
using UnityEngine;


public class SoundManager : MonoBehaviour
{

    public Sound[] sounds;
    //reference to current instance
    public static SoundManager instance;

    // Awake is called before the start function
    void Awake()
    {
        //makes sure there is only ever one instance of the manager in a scene
        if (instance == null)
		{
            instance = this;
		}
		else
		{
            Destroy(gameObject);
            return;
		}

        //manager persists between scenes
        DontDestroyOnLoad(gameObject);

        //creates and populates an audio source for each sound
        foreach (Sound s in sounds){
            s.source = gameObject.AddComponent<AudioSource>();
            s.source.clip = s.clip;

            s.source.volume = s.volume;
            s.source.pitch = s.pitch;
            s.source.loop = s.loop;
		}
    }

    //public function to play any loaded sound
    public void Play(string name)
    {
        //finds and plays specified sound "name"
        foreach (Sound s in sounds)
        {
            Sound sound = Array.Find(sounds, sound => sound.name == name);
            if (sound == null)
			{
                Debug.LogWarning("Sound: " + name + " not found!!");
                return;
            }
            sound.source.Play();
        }
    }
}
