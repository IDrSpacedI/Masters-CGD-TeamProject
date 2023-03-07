using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Hiring : MonoBehaviour
{

    public bool hired;
    public Friend_Travel_State travelState;
    public GameObject mainBase;
    public GameObject interactbox;
    public GameObject interactboxHire;
    public GameObject moneysystem;

    // Start is called before the first frame update
    void Start()
    {
        hired = false;
        interactbox = GameObject.Find("GameManager").GetComponent<Gamemanager>().TextBox;
        interactboxHire = GameObject.Find("GameManager").GetComponent<Gamemanager>().HiredBox;
        mainBase = GameObject.Find("GameManager").GetComponent<Gamemanager>().mainBase;
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            moneysystem = other.gameObject;
            if (hired == false)
            {
                interactbox.SetActive(true);
                if (Input.GetKey(KeyCode.E))
                {
                    if(moneysystem.GetComponent<MoneySystem>().reduceMoney(5) == true)
                    {
                        interactbox.SetActive(false);
                        interactboxHire.SetActive(true);
                        hired = true;
                        travelState.destination = mainBase;
                        travelState.go = true;
                        StartCoroutine(Text());
                    }
                    else
                    {
                        Debug.Log("Not Enough Money");
                    }
                }
            }


        }
    }

    public IEnumerator Text()
    {
        yield return new WaitForSeconds(2f);
        interactboxHire.SetActive(false);
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            interactbox.SetActive(false);
        }
    }
}
