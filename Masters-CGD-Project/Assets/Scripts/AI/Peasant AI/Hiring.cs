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
    public GameObject Interactbox;
    public GameObject Interactbox_hire;
    public GameObject moneysystem;

    // Start is called before the first frame update
    void Start()
    {
        hired = false;
        Interactbox = GameObject.Find("GameManager").GetComponent<Gamemanager>().TextBox;
        Interactbox_hire = GameObject.Find("GameManager").GetComponent<Gamemanager>().HiredBox;
        mainBase = GameObject.Find("GameManager").GetComponent<Gamemanager>().mainBase;
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            moneysystem = other.gameObject;
            if (hired == false)
            {
                Interactbox.SetActive(true);
                if (Input.GetKey(KeyCode.E))
                {
                    if(moneysystem.GetComponent<MoneySystem>().reduceMoney(5) == true)
                    {
                        Interactbox.SetActive(false);
                        Interactbox_hire.SetActive(true);
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
        Interactbox_hire.SetActive(false);
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            Interactbox.SetActive(false);
        }
    }
}
