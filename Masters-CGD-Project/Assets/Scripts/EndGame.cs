using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Cinemachine;

public class EndGame : MonoBehaviour
{


    //bool to activate and diactivate script
    public bool active = true;
    public bool action = false;

    public GameObject TextPrompt;

    public Animator transition;

    public BuildInteraction build;

    DaysCounter Day;
    public int day;

    private LightingManager lm;

    public CinemachineVirtualCamera cam1;
    public GameObject Timeline;

    private void Start()
    {
         references();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && action == true && active == true && build.currentLevel == 3 && lm.dayCount == 6)
        {
            ChangeScene();
        }

        if(build.currentLevel == 3 && lm.dayCount == 6)
        {
            StartCoroutine(EndDelay());
        }
    }

    //sets UI elemt to active when player enters
    void OnTriggerEnter(Collider collision)
    {
    

        if (collision.transform.tag == "Player")
        {
            //Debug.Log("touching");
            action = true;

            // Debug.Log(day);
            if (active == true && build.currentLevel == 3 && lm.dayCount == 6)
            {
                TextPrompt.SetActive(true);
                //Pickup.gameObject.SetActive(true);
            }
        }

    }

    void OnTriggerExit(Collider collision)
    {
        // Debug.Log("Exitted");
        TextPrompt.SetActive(false);
        action = false;
    }

    public void ChangeScene()
    {
        StartCoroutine(AnimDelay());
            //load endgame scene
            //SceneManager.LoadScene("EndGame");

    }

    public IEnumerator AnimDelay()
    {
        transition.Play("EndGameTransition");
        yield return new WaitForSeconds(3f);
        SceneManager.LoadScene("EndGame");

    }

    public IEnumerator EndDelay()
    {
        cam1.Priority = 11;
        yield return new WaitForSeconds(1f);
        Timeline.SetActive(true);
        yield return new WaitForSeconds(7f);
        cam1.Priority = 9;

    }

    private void references()
    {
        lm = GameObject.FindGameObjectWithTag("GM").GetComponent<LightingManager>();
        day = lm.dayCount;
    }
}
