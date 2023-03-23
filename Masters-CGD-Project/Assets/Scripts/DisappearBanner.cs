using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisappearBanner : MonoBehaviour
{
    public BuildInteraction buildInteraction;
    // Update is called once per frame
    void Update()
    {
        if (buildInteraction.currentLevel +1 == buildInteraction.levels.Length)
        {
            Debug.Log("Deactivate");
            gameObject.SetActive(false);
        }
        else
        {
            gameObject.SetActive(true);
        }
    }
}
