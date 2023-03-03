using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class DaysCounter : MonoBehaviour
{

    public int dayCount;
    private LightingManager lm;
    private float time;
    private float temp;

    public TextMeshProUGUI dayTxt;

    // Start is called before the first frame update
    void Start()
    {
        lm = FindObjectOfType<LightingManager>();
        time = lm.TimeOfDay;
        temp = time;
    }

    // Update is called once per frame
    void Update()
    {
        dayTxt.text = (dayCount+1).ToString();
        temp = lm.TimeOfDay;
        if (temp < time)
		{
            dayCount++;
        }
        time = lm.TimeOfDay;
    }
}
