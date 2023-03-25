using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisappearBanner : MonoBehaviour
{
    public BuildInteraction buildInteraction;
    public GameObject flag;
    // Update is called once per frame
    void Update()
    {
        if (buildInteraction.currentLevel +1 == buildInteraction.levels.Length)
        {
            flag.SetActive(false);
        }
        else
        {
            flag.SetActive(true);
        }
    }
}
