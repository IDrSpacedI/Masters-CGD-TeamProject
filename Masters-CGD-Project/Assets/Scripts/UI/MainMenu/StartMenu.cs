using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartMenu : MonoBehaviour
{
    public Animator fade;
    public GameObject start;
    public GameObject menu;
    public GameObject transition;
    public GameObject title;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            fade.Play("Fadein");
            StartCoroutine(speed());
          
           

        }
    }

    public IEnumerator speed()
    {
        yield return new WaitForSeconds(1.3f);
        start.SetActive(false);
        menu.SetActive(true);
        title.SetActive(false);
       
    }
}
