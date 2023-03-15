using Cinemachine;
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

    public Animator transition;

    public BuildInteraction build;

    public int day;

    private LightingManager lm;

    public GameObject Timeline;
    public CinemachineVirtualCamera vcam;


    private void Start()
    {
         references();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E) && action == true && active == true)
        {
            ChangeScene();
        }

        if(build.currentLevel == 3 && lm.dayCount == 6)
        {
            Timeline.SetActive(true);
            vcam.Priority = 11;
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

        yield return new WaitForSeconds(7f);
        vcam.Priority = 9;

    }

    private void references()
    {
        lm = GameObject.FindGameObjectWithTag("GM").GetComponent<LightingManager>();
        day = lm.dayCount;
    }
}
