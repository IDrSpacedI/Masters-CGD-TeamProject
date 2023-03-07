using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DaysCounter : MonoBehaviour
{

    public int dayCount;
    private LightingManager lm;
    public float time;
    private bool newDay = true;

    

    // Start is called before the first frame update
    void Start()
    {
        lm = FindObjectOfType<LightingManager>();
        time = lm.TimeOfDay;
    }

    // Update is called once per frame
    void Update()
    {
        if (newDay && time < 2)
        {
            newDay = false;
            dayCount ++;
            //
        }
        if (time >= 23f)
		{
            newDay = true;
		}
        time = lm.TimeOfDay;
    }
}
