using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NewClock : MonoBehaviour
{

    TimeManager tm;
    public RectTransform skyDome;
    float nighthoursToDegree, dayHoursToDegree;

    void Start()
    {
        tm = FindObjectOfType<TimeManager>();


        nighthoursToDegree = 180 / (TimeManager.hoursInDay * tm.nightDuration);
        dayHoursToDegree = 180 / (TimeManager.hoursInDay * (1 - tm.nightDuration));
        
    }


    void Update()
    {
      if(((tm.getHour() < tm.sunriseHour || tm.getHour() > tm.GetSunset())  && tm.sunriseHour < tm.GetSunset())||
        ((tm.getHour() < tm.sunriseHour || tm.getHour() > tm.GetSunset()) && tm.sunriseHour > tm.GetSunset()))


      {
            skyDome.Rotate(0, 0, -Time.deltaTime * TimeManager.hoursInDay * nighthoursToDegree / tm.dayDuration);
      }
      else
      {
            skyDome.Rotate(0, 0, -Time.deltaTime * TimeManager.hoursInDay * dayHoursToDegree / tm.dayDuration);
      }
    }
}
