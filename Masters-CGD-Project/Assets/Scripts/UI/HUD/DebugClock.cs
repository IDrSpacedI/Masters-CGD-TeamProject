using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

// day and night clock by Dan Pos - Game Dev Tutorials!
public class DebugClock : MonoBehaviour
{
    [Header("Reference")]
    TimeManager tm;
    [Header("UI")]
    public TextMeshProUGUI display;

    // Start is called before the first frame update
    void Start()
    {
        tm = FindObjectOfType<TimeManager>(); // find object

    }

    // Update is called once per frame
    void Update()
    {
        display.text = tm.Clock24Hour(); // set text to display timer
    }
}
