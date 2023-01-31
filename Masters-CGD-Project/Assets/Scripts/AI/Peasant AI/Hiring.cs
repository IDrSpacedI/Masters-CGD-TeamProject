using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Hiring : MonoBehaviour
{

    public bool hired;
    public TextMeshProUGUI interactText;
    public Friend_Travel_State travelState;
    public GameObject mainBase;

    // Start is called before the first frame update
    void Start()
    {
        hired = false;
        interactText = GameObject.Find("GameManager").GetComponent<Gamemanager>().AI_Interact;
        mainBase = GameObject.Find("GameManager").GetComponent<Gamemanager>().mainBase;
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            if (hired == false)
            {
                interactText.text = "Press E to recruit";
                if (Input.GetKey(KeyCode.E))
                {
                    interactText.text = "Hired!";
                    hired = true;
                    travelState.destination = mainBase;
                    travelState.go = true;
                    StartCoroutine(Text());
                }
            }


        }
    }

    public IEnumerator Text()
    {
        yield return new WaitForSeconds(2f);
        interactText.text = "";
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            interactText.text = "";
        }
    }
}
