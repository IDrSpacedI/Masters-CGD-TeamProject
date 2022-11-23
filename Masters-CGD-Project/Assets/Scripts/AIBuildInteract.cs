using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class AIBuildInteract : MonoBehaviour
{
    //public GameObject armorStand;
    public GameObject armorPrefab;
    public static int armorAmount;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(armorAmount);
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("amrorrrrrrrrrrrrrr");

            if (Input.GetKey(KeyCode.E))
            {
                Instantiate(armorPrefab, transform.position, transform.rotation);
                armorAmount++;
            }
        }
    }
}
