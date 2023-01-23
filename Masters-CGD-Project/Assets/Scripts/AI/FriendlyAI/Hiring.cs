using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Hiring : MonoBehaviour
{

    public bool hired;
    public TextMeshProUGUI interactText;
    public Friend_Travel_State travelState;
    public Transform baseTrans;

    // Start is called before the first frame update
    void Start()
    {
        hired = false;
        interactText = GameObject.Find("AI_Text").GetComponent<TextMeshProUGUI>();
        baseTrans = GameObject.Find("Base").GetComponent<Transform>();
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
                    travelState.destination = new Vector3 (baseTrans.position.x, transform.position.y, transform.position.z);
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
