using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DaysCounter : MonoBehaviour
{

    public int dayCount;
    private LightingManager lm;
    private float time;
    private float temp;

    // Start is called before the first frame update
    void Start()
    {
        lm = FindObjectOfType<LightingManager>();
        time = lm.TimeOfDay;
        temp = time;
    }

    // Update is called once per frame
    void Update()
    {
        temp = lm.TimeOfDay;
        if (temp < time)
		{
            dayCount++;
        }
        time = lm.TimeOfDay;
    }
}
