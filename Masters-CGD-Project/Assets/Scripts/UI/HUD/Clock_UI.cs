using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Clock_UI : MonoBehaviour
{

    TimeManager tm;

    public RectTransform hand;
    public Image nightbackground;

    const float hoursToDegree = 360 / 24;
    float StartRoatation;

    void Start()
    {
        tm = FindObjectOfType<TimeManager>();
        nightbackground.fillAmount = tm.nightDuration;
        StartRoatation = tm.sunriseHour * hoursToDegree;
    }

    // Update is called once per frame
    void Update()
    {
        hand.rotation = Quaternion.Euler(0, 0,StartRoatation - tm.getHour() * hoursToDegree);
    }
}
