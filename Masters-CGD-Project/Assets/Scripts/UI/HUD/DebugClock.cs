using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DebugClock : MonoBehaviour
{
    TimeManager tm;
    public TextMeshProUGUI display;

    // Start is called before the first frame update
    void Start()
    {
        tm = FindObjectOfType<TimeManager>();

    }

    // Update is called once per frame
    void Update()
    {
        display.text = tm.Clock24Hour();
    }
}
