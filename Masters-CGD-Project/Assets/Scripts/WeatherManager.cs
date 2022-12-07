using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeatherManager : MonoBehaviour
{
    private bool lightning;

    // Update is called once per frame
    void Update()
    {
        if (FindObjectOfType<DaysCounter>().dayCount == FindObjectOfType<Raining>().nextRain && FindObjectOfType<LightingManager>().TimeOfDay >= FindObjectOfType<Raining>().rainStartTime)
		{
            if (FindObjectOfType<Raining>().nextRain == FindObjectOfType<Raining>().nextLightning)
			{
                lightning = true;
			}
			else
			{
                lightning = false;
			}
            FindObjectOfType<Raining>().Rain(lightning);
		}
    }
}
