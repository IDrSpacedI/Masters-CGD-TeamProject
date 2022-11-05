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
            if (s.audioSource != null)
            {
                s.source = s.audioSource.AddComponent<AudioSource>();
			}
			else
			{
                s.source = gameObject.AddComponent<AudioSource>();
            }

            if (s.clip != null && !s.randomArray)
            {
                s.source.clip = s.clip;
            }

            s.source.volume = s.volume;
            s.source.pitch = s.pitch;
            s.source.loop = s.loop;
            s.source.outputAudioMixerGroup = s.audioType;
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
            if (!sound.randomArray)
            {
                sound.source.Play();
			}
			else
			{
                var p = sound.source.pitch;
                var v = sound.source.volume;
                sound.source.pitch = UnityEngine.Random.Range(p - .2f, p + .2f);
                sound.source.volume = UnityEngine.Random.Range(v - .2f, v + .2f);
                sound.source.clip = sound.soundsArray[UnityEngine.Random.Range(0, s.soundsArray.Length)];
                sound.source.Play();
                sound.source.pitch = p;
                sound.source.volume = v;
            }
        }
    }
}
