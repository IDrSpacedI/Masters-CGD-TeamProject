using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Toggle : MonoBehaviour
{
    [Header("Bool")]
    public bool toggler;
    [Header("Array")]
    public GameObject[] canvas;
    [Header("Animators")]
    public Animator animator;
    public Animator c_anim;

    public void Awake()
    {
        // play animation
        animator.Play("HUD");
        c_anim.Play("Clock");
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

    }
}
