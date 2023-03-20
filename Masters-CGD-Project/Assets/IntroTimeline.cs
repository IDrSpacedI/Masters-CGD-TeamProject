using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public class IntroTimeline : MonoBehaviour
{
    public CinemachineVirtualCamera cam1;


    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(SwapCamera());
    }

    public IEnumerator SwapCamera()
    {
        yield return new WaitForSeconds(20f);
        cam1.Priority = 9;
    }

}
