using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeatherManager : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (FindObjectOfType<DaysCounter>().dayCount == FindObjectOfType<Raining>().nextRain && FindObjectOfType<LightingManager>().TimeOfDay >= FindObjectOfType<Raining>().rainStartTime)
		{
            FindObjectOfType<Raining>().Rain();
		}
    }
}
