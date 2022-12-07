using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Raining : MonoBehaviour
{

    public float rainStartTime = 20f;
    public float rainStopTime = 5f;
    private float time;
    private int days;
    public int nextRain = 1;
    public int nextLightning = 1;
    public bool raining;
    public bool storm;

    public ParticleSystem rain;
    public ParticleSystem clouds;
    public ParticleSystem mist;
    public ParticleSystem lightning;

    void Awake()
    {
        rain.Stop();
        clouds.Stop();
        mist.Stop();
        lightning.Stop();
    }

	private void Update()
	{
        if (raining)
		{
            time = FindObjectOfType<LightingManager>().TimeOfDay;
            if (time >= rainStartTime || time <= rainStopTime)
			{
                rain.Play();
                clouds.Play();
                mist.Play();
                if (storm)
				{
                    Debug.Log("lightning");
                    lightning.Play();
				}
                return;
            }
            rain.Stop();
            clouds.Stop();
            mist.Stop();
            lightning.Stop();
            days = FindObjectOfType<DaysCounter>().dayCount;
            nextRain = days + Mathf.RoundToInt(Random.Range(1f, 5f));
            nextLightning = days + Mathf.RoundToInt(Random.Range(nextRain-1, nextRain+1));
            Debug.Log(nextRain);
            Debug.Log(nextLightning);
            raining = false;
            storm = false;
        }
	}

	public void Rain(bool light)
    {
        raining = true;
        storm = light;
    }

}

