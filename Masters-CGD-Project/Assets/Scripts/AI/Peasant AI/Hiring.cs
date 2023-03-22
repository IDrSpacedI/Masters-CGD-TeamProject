using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Hiring : MonoBehaviour, IInteractable
{

    public bool hired;
    public Friend_Travel_State travelState;
    public GameObject mainBase;
    public GameObject interactbox;
    public GameObject interactboxHire;
    public GameObject moneysystem;

    public string InteractionPrompt => null;

    // Start is called before the first frame update
    void Start()
    {
        hired = false;
        interactbox = GameObject.Find("GameManager").GetComponent<Gamemanager>().TextBox;
        interactboxHire = GameObject.Find("GameManager").GetComponent<Gamemanager>().HiredBox;
        mainBase = GameObject.Find("GameManager").GetComponent<Gamemanager>().mainBase;
        moneysystem = GameObject.FindGameObjectWithTag("Player");
    }

    //private void OnTriggerStay(Collider other)
    //{
    //    if (other.tag == "Player")
    //    {
    //        moneysystem = other.gameObject;
    //        if (hired == false)
    //        {
    //            interactbox.SetActive(true);
    //            /*if (!other.gameObject.GetComponent<Interactor>().collidedobject)
    //            {
    //                other.gameObject.GetComponent<Interactor>().collidedobject = this.gameObject;
    //                //TextBox.SetActive(true);
    //                interactbox.SetActive(true);
    //            }*/

    //        }


    //    }
    //}

    public IEnumerator Text()
    {
        yield return new WaitForSeconds(2f);
        interactboxHire.SetActive(false);
    }

    //public void OnTriggerExit(Collider other)
    //{

    //}

    //
    public bool Interact(Interactor interactor)
    {
        if (moneysystem.GetComponent<MoneySystem>().reduceMoney(5) == true)
        {
            interactbox.SetActive(false);
            interactboxHire.SetActive(true);
            hired = true;
            travelState.destination = mainBase;
            travelState.go = true;
            StartCoroutine(Text());
            return true;
        }
        else
        {
            Debug.Log("Not Enough Money");
        }
        return false;
    }

    public void OnEnter()
    {
        if (hired == false)
        {
            interactbox.SetActive(true);
        }
    }

    public void OnLeave()
    {
        interactbox.SetActive(false);
    }
}
