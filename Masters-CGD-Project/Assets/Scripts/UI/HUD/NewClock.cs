using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


// day and night clock by Dan Pos - Game Dev Tutorials!
public class NewClock : MonoBehaviour
{
    [Header("References")]
    private LightingManager lm;
    public RectTransform skyDome;
    [Header("float")]
    private float angle;

    void Start()
    {
        // sets clock start position
        lm = GameObject.FindWithTag("GM").GetComponent<LightingManager>();
        angle = (360 / TimeManager.hoursInDay) * lm.TimeOfDay;
    }


    void Update()
    {
        // updates Position
        angle = (360 / TimeManager.hoursInDay) * lm.TimeOfDay;
        skyDome.rotation = Quaternion.Euler(0, 0, - angle + 180);
    }
}
