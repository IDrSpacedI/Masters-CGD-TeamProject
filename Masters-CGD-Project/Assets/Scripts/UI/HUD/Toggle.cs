using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Toggle : MonoBehaviour
{
    public bool toggler;
    public GameObject[] canvas;

    void Update()
    {
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

    }
}
