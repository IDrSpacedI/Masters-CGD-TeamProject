using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeatherManager : MonoBehaviour
{
    private bool lightning;
	private LightingManager lm;
	private Raining rain;

	private void Start()
	{
		lm = GameObject.FindWithTag("GM").GetComponent<LightingManager>();
		rain = FindObjectOfType<Raining>();
	}

	// Update is called once per frame
	void Update()
    {
        if (lm.dayCount == rain.nextRain && lm.TimeOfDay >= rain.rainStartTime)
		{
            if (rain.nextRain == rain.nextLightning)
			{
                lightning = true;
			}
			else
			{
                lightning = false;
			}
            rain.Rain(lightning);
		}
    }
}
