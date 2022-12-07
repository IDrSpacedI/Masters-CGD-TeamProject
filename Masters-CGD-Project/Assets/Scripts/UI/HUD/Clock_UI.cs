using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

// day and night clock by Dan Pos - Game Dev Tutorials!
public class Clock_UI : MonoBehaviour
{
    [Header("Reference")]
    TimeManager tm;
    [Header("UI")]
    public RectTransform hand;
    public Image nightbackground;
    [Header("Floats")]
    const float hoursToDegree = 360 / 24;
    float StartRoatation;

    void Start()
    {
        tm = FindObjectOfType<TimeManager>(); // find object
        nightbackground.fillAmount = tm.nightDuration; // fill amount is equall to night duration
        StartRoatation = tm.sunriseHour * hoursToDegree; // rotation start is equall to sunrise hour times to hours to degree
    }

    // Update is called once per frame
    void Update()
    {
        hand.rotation = Quaternion.Euler(0, 0,StartRoatation - tm.getHour() * hoursToDegree); // calculates speed of hand rotation
    }
}
