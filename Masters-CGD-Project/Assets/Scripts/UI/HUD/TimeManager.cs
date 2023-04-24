using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// script by Oliver Lancashire
// sid 1901981

// day and night clock by Dan Pos - Game Dev Tutorials!
public class TimeManager : MonoBehaviour
{
    [Header("int")]
    public const int hoursInDay = 24, minutesInHour = 60;
    [Header("float")]
    public float dayDuration = 30f;
    float totalTime = 0;
    float currentTime = 0;
    public float nightDuration = 0.4f;
    public float sunriseHour = 6;
    private float speedFactor;
    [Header("references")]
    private LightingManager lm;

	private void Start()
	{
        // set references
        lm = GameObject.FindWithTag("GM").GetComponent<LightingManager>();
        speedFactor = FindObjectOfType<LightingManager>().speedFactor;
	}

	void Update()
    {
        // updates time
        totalTime += Time.deltaTime * speedFactor;
        //currentTime = totalTime % dayDuration;\
        currentTime = lm.TimeOfDay;
    }

    /// <summary>
    /// return hour
    /// </summary>
    /// <returns></returns>
    public float getHour()
    {
        return currentTime * hoursInDay / dayDuration;
    }
    /// <summary>
    /// return minutes
    /// </summary>
    /// <returns></returns>
    public float GetMinutes()
    {
        return (currentTime * hoursInDay * minutesInHour / dayDuration) % minutesInHour;
    }

    /// <summary>
    /// 24 hours clock
    /// </summary>
    /// <returns></returns>
    public string Clock24Hour()
    {
        //00:00
        return Mathf.FloorToInt(getHour()).ToString("00") + ":" + Mathf.FloorToInt(GetMinutes()).ToString("00");
    }
    /// <summary>
    /// 12 hour clock
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
    /// set sunrise
    /// </summary>
    /// <returns></returns>
    public float GetSunset()
    {
        return (sunriseHour + (1 - nightDuration)*hoursInDay) % hoursInDay;
    }
}
