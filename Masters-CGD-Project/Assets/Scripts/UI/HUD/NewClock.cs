using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NewClock : MonoBehaviour
{
    private LightingManager lm;
    public RectTransform skyDome;
    private float angle;

    void Start()
    {
        lm = GameObject.FindWithTag("GM").GetComponent<LightingManager>();
        angle = (360 / TimeManager.hoursInDay) * lm.TimeOfDay;
    }


    void Update()
    {
        angle = (360 / TimeManager.hoursInDay) * lm.TimeOfDay;
        skyDome.rotation = Quaternion.Euler(0, 0, - angle + 180);
    }
}
