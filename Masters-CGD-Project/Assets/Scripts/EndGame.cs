using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EndGame : MonoBehaviour
{


    //bool to activate and diactivate script
    public bool active = true;
    public bool action = false;

    public GameObject TextPrompt;

    public BuildInteraction build;

    private void Start()
    {
         
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && active == true && action == true && build.level3 == true)
        {
            //load endgame scene
            SceneManager.LoadScene("EndGame");

        }
    }

    //sets UI elemt to active when player enters
    void OnTriggerEnter(Collider collision)
    {
        //Debug.Log("TRIGGER!!!!!!!!!!");
        if (active == true)
        {
            TextPrompt.SetActive(true);
            //Pickup.gameObject.SetActive(true);
        }

        if (collision.transform.tag == "Player")
        {
            //Debug.Log("touching");
            action = true;
        }

    }

    void OnTriggerExit(Collider collision)
    {
        // Debug.Log("Exitted");
        TextPrompt.SetActive(false);
        action = false;
    }
}
