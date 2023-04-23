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
    public bool hasCalled = false;

    DaysCounter Day;
    public int day;

    private LightingManager lm;

    public CinemachineVirtualCamera cam1;
    public GameObject Timeline;
    public GameObject HUD;
    public GameObject texInteraction;
    public GameObject clock;


    private void Start()
    {
         references();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && action == true && active == true && build.currentLevel == 3 && lm.dayCount >= 5)
        {
            ChangeScene();
        }

        if(build.currentLevel == 3 && lm.dayCount >= 5 && !hasCalled)
        {
            hasCalled = true;
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
            if (active == true && build.currentLevel == 3 && lm.dayCount >= 5)
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
        SceneManager.LoadScene("EndGame");

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
        HUD.SetActive(false);
        texInteraction.SetActive(false);
        clock.SetActive(false);
        yield return new WaitForSeconds(7f);
        cam1.Priority = 9;
        HUD.SetActive(true);
        texInteraction.SetActive(true);
        clock.SetActive(true);

    }

    private void references()
    {
        lm = GameObject.FindGameObjectWithTag("GM").GetComponent<LightingManager>();
        day = lm.dayCount;
    }
}
