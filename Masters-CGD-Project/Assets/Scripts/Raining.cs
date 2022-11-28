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
    public bool raining;

    public ParticleSystem rain;
    public ParticleSystem clouds;
    public ParticleSystem mist;

    void Awake()
    {
        rain.Stop();
        clouds.Stop();
        mist.Stop();
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
                return;
            }
            rain.Stop();
            clouds.Stop();
            mist.Stop();
            days = FindObjectOfType<DaysCounter>().dayCount;
            nextRain = days + Mathf.RoundToInt(Random.Range(1f, 2f));
            Debug.Log(nextRain);
            raining = false;
        }
	}

	public void Rain()
    {
        raining = true;
    }

}

