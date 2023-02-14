using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartMenu : MonoBehaviour
{
    public Animator fade;
    public GameObject start;
    public GameObject menu;
    public GameObject transition;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            fade.Play("Fadein");
            start.SetActive(false);
            menu.SetActive(true);
            transition.SetActive(false);

        }
    }
}
