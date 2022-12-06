using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// day and night clock by Dan Pos - Game Dev Tutorials!
public class TimeManager : MonoBehaviour
{
    [Header("Int")]
    public const int hoursInDay = 24, minutesInHour = 60;

    [Header("Floats")]
    public float dayDuration = 30f;
    float totalTime = 0;
    float currentTime = 0;
    public float nightDuration = .4f;
    public float sunriseHour = 6;
    private float speedFactor;

	private void Start()
	{
        speedFactor = FindObjectOfType<LightingManager>().speedFactor; // find game object
	}

	void Update()
    {
        totalTime += Time.deltaTime * speedFactor; // total time calculator
        currentTime = totalTime % dayDuration; // current time calculated
    }

    /// <summary>
    /// get current hour
    /// </summary>
    /// <returns></returns>
    public float getHour()
    {
        return currentTime * hoursInDay / dayDuration;
    }
    /// <summary>
    /// get current minutes
    /// </summary>
    /// <returns></returns>
    public float GetMinutes()
    {
        return (currentTime * hoursInDay * minutesInHour / dayDuration) % minutesInHour;
    }

    /// <summary>
    /// calculate 24 hours clock
    /// </summary>
    /// <returns></returns>
    public string Clock24Hour()
    {
        //00:00
        return Mathf.FloorToInt(getHour()).ToString("00") + ":" + Mathf.FloorToInt(GetMinutes()).ToString("00");
    }
    /// <summary>
    /// calculate 12 hours clock
    /// </summary>
    /// <returns></returns>
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
    /// <summary>
    /// get current sunset time 
    /// </summary>
    /// <returns></returns>
    public float GetSunset()
    {
        return (sunriseHour + (1 - nightDuration)*hoursInDay) % hoursInDay;
    }
}
