using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// script by Oliver Lancashire
// sid 1901981

// day and night clock by Dan Pos - Game Dev Tutorials!
public class TimeManager : MonoBehaviour
{

    public const int hoursInDay = 24, minutesInHour = 60;

    public float dayDuration = 30f;

    float totalTime = 0;
    float currentTime = 0;

    public float nightDuration = 0.4f;
    public float sunriseHour = 6;

    private float speedFactor;

    private LightingManager lm;

	private void Start()
	{
        lm = GameObject.FindWithTag("GM").GetComponent<LightingManager>();
        speedFactor = FindObjectOfType<LightingManager>().speedFactor;
	}

	void Update()
    {
        totalTime += Time.deltaTime * speedFactor;
        //currentTime = totalTime % dayDuration;\
        currentTime = lm.TimeOfDay;
    }

    public float getHour()
    {
        return currentTime * hoursInDay / dayDuration;
    }

    public float GetMinutes()
    {
        return (currentTime * hoursInDay * minutesInHour / dayDuration) % minutesInHour;
    }

    public string Clock24Hour()
    {
        //00:00
        return Mathf.FloorToInt(getHour()).ToString("00") + ":" + Mathf.FloorToInt(GetMinutes()).ToString("00");
    }

    public string Clock12Hour()
    {
        int hour = Mathf.FloorToInt(getHour());
        string abbreviation = "AM";
        if(hour >= 12)
        {
            abbreviation = "PM";
            hour -= 12;

        }
        if (hour == 0) hour = 12;
        return hour.ToString("00") + ":" + Mathf.FloorToInt(GetMinutes()).ToString("00") + " " + abbreviation;
    }

    public float GetSunset()
    {
        return (sunriseHour + (1 - nightDuration)*hoursInDay) % hoursInDay;
    }
}
