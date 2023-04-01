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
		PlayerMovement.disableMovement = true;
        Cursor.visible = false;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.H))
        {
            PlayerMovement.disableMovement = false;
            cam1.Priority = 9;
            Ui.SetActive(true);
            cameraObj.SetActive(true);
            texinteraction.SetActive(true);
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
        texinteraction.SetActive(true);
    }

}
