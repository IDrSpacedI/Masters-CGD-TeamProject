using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ToggleDebug : MonoBehaviour
{
    [Header("Bool")]
    public bool toggler;
    [Header("Array")]
    public GameObject[] canvas;
    public GameObject debug;
    private bool toggleStateHealthMoney = false;
    public GameObject[] healthMoney;

    public void Start()
    {
        for(int i = 0; i < canvas.Length; i++)
        {
            canvas[i].SetActive(false);
        }
    }

    void Update()
    {
        // toggles text on and off
        if (Input.GetKeyDown(KeyCode.T))
        {
            if (toggler == true)
            {
                for (int i = 0; i < canvas.Length; i++)
                {
                    if (canvas[i])
                    {
                        canvas[i].SetActive(true);
                    }
                    else
                        break;
                }
                toggler = !toggler;
            }
            else if (toggler == false)
            {
                for (int i = 0; i < canvas.Length; i++)
                {
                    if (canvas[i])
                    {
                        canvas[i].SetActive(false);
                    }
                    else
                        break;
                }
                toggler = !toggler;
            }

        }
        if (Input.GetKeyDown(KeyCode.Q))
        {
            toggleStateHealthMoney = !toggleStateHealthMoney;
            for (int i = 0; i < healthMoney.Length; i++)
            {
                healthMoney[i].SetActive(toggleStateHealthMoney);
            }
        }

    }
}
