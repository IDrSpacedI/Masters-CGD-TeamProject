using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DaysCounter : MonoBehaviour
{

    public int dayCount;
    private float time;
    private float temp;

    // Start is called before the first frame update
    void Start()
    {
        time = FindObjectOfType<LightingManager>().TimeOfDay;
        temp = time;
    }

    // Update is called once per frame
    void Update()
    {
        temp = FindObjectOfType<LightingManager>().TimeOfDay;
        if (temp < time)
		{
            dayCount++;
            time = FindObjectOfType<LightingManager>().TimeOfDay;
        }
		else
		{
            time = FindObjectOfType<LightingManager>().TimeOfDay;
        }
    }
}
