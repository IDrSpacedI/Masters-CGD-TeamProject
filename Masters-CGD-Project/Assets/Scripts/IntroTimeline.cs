using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class IntroTimeline : MonoBehaviour
{
    public CinemachineVirtualCamera cam1;
    public GameObject Ui;
    public GameObject cameraObj;
    public GameObject texinteraction;
    bool introcompleted;



    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SwapCamera());
        Ui.SetActive(false);
        cameraObj.SetActive(false);
        texinteraction.SetActive(false);
    }

    private void Update()
    {
        if(!introcompleted)
        PlayerMovement.disableMovement = true;

        if (Input.GetKeyDown(KeyCode.H))
        {
            cam1.Priority = 9;
        }
    }

    public IEnumerator SwapCamera()
    {
        yield return new WaitForSeconds(20f);
        introcompleted = true;
        PlayerMovement.disableMovement = false;
        cam1.Priority = 9;
        Ui.SetActive(true);
        cameraObj.SetActive(true);
        texinteraction.SetActive(true);
    }

}
