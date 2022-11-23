using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SoundManager : MonoBehaviour
{

    public Sound[] sounds;
    //reference to current instance
    public static SoundManager instance;

    // Awake is called before the start function
    void Awake()
    {
        instance = this;
        
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

            if (s.spactialSound)
			{
                s.source.rolloffMode = AudioRolloffMode.Linear;
                s.source.spatialBlend = 1f;
                s.source.maxDistance = s.maxDistance;
                s.source.minDistance = s.minDistance;
            }

            s.source.volume = s.volume;
            s.source.pitch = s.pitch;
            s.source.loop = s.loop;
            s.source.outputAudioMixerGroup = s.audioType;
            if (s.playOnStart && s.active)
			{
                PlaySound(s.name);
			}
		}
    }

    //public function to play any loaded sound
    public void PlaySound(string name)
    {
        //finds and plays specified sound "name"
        foreach (Sound s in sounds)
        {
            Sound sound = Array.Find(sounds, sound => sound.name == name);
            if (sound == null || !sound.active)
			{
                Debug.LogWarning("Sound: " + name + " cannot be played");
                return;
            }
            if (!sound.randomArray)
            {
				if (sound.fadeIn)
				{
                    sound.source.volume = 0;
                    sound.source.Play();
                    StartCoroutine(FadeSound.StartFade(sound.source, sound.fadeInTime, sound.volume));
                }
				else
				{
                    sound.source.Play();
                }
            }
			else
			{
                var p = sound.source.pitch;
                var v = sound.source.volume;
                sound.source.pitch = UnityEngine.Random.Range(p - (p*0.05f), p + (p * 0.05f));
                sound.source.volume = UnityEngine.Random.Range(v - (v * 0.05f), v + (v * 0.05f));
                sound.source.clip = sound.soundsArray[UnityEngine.Random.Range(0, s.soundsArray.Length)];
                sound.source.Play();
                sound.source.pitch = p;
                sound.source.volume = v;
            }
        }
    }

	public void StopSound(string name)
	{
        Sound sound = Array.Find(sounds, sound => sound.name == name);
        if (sound == null)
        {
            Debug.LogWarning("Sound: " + name + " not found!!");
            return;
        }
        if (sound.fadeOut)
		{
            StartCoroutine(FadeSound.StartFade(sound.source, sound.fadeOutTime, 0)); 
		}
        sound.source.Stop();
    }
}

public static class FadeSound
{
    public static IEnumerator StartFade(AudioSource source, float duration, float targetVolume)
    {
        float currentTime = 0;
        float start = source.volume;
        while (currentTime < duration)
        {
            currentTime += Time.deltaTime;
            source.volume = Mathf.Lerp(start, targetVolume, currentTime / duration);
            yield return null;
        }
        yield break;
    }
}