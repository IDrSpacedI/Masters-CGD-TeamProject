using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnterTrigger : MonoBehaviour
{
    public GameObject[] AI;

    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("AI1"))
        {
            AI[0] = AI[0];
            AI[1] = AI[1]; 
            AI[2] = AI[2];

        }
        else if (other.gameObject.CompareTag("AI2"))
        {
            AI[0] = AI[0];
            AI[1] = AI[1];
            AI[2] = AI[2];
        }
        else if (other.gameObject.CompareTag("AI3"))
        {
            AI[0] = AI[0];
            AI[1] = AI[1];
            AI[2] = AI[2];
        }
    }
    // not sure if this works. need's some testing. not fun logic xd
}

