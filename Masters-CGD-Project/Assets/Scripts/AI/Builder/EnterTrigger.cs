using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnterTrigger : MonoBehaviour
{
    public GameObject AI;

    public void OnTriggerStay(Collider other)
    {
        if (other.gameObject.CompareTag("AI"))
        {
            AI = GameObject.Find("Friendly");
        }
    }
}

