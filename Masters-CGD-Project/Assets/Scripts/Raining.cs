using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Raining : MonoBehaviour
{

    public float rainStartTime = 20f;
    public float rainStopTime = 5f;
    private float time;

    public ParticleSystem rain;
    public ParticleSystem clouds;
    public ParticleSystem mist;

    void Start()
    {
        rain.Stop();
        clouds.Stop();
        mist.Stop();
    }

    // Update is called once per frame
    void Update()
    {
        time = FindObjectOfType<LightingManager>().TimeOfDay;
        if (time >=  rainStartTime || time <= rainStopTime)
		{
            rain.Play();
            clouds.Play();
            mist.Play();
		}
		else {
            rain.Stop();
            clouds.Stop();
            mist.Stop();
        }
    }
}
