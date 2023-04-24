using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// script by Oliver Lancashire
// sid 1901981
public class StartMenu : MonoBehaviour
{
    public Animator fade;
    public GameObject start;
    public GameObject menu;
    public GameObject transition;

    void Update()
    {
        // any key to load
        if (Input.anyKey)
        {
            fade.Play("Fadein");
            StartCoroutine(speed());
        }
    }

    /// <summary>
    ///  changes menu
    /// </summary>
    /// <returns></returns>
    public IEnumerator speed()
    {
        yield return new WaitForSeconds(1.3f);
        start.SetActive(false);
        menu.SetActive(true);

    }


}

