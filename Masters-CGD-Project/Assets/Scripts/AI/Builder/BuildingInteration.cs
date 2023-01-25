using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BuildingInteration : MonoBehaviour
{
    public bool Flagged;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            if (Input.GetKeyDown(KeyCode.E))
            {
                Debug.Log("Bought");
                Flagged = true;
            }
        }
    }
}
