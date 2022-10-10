using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GetMoney : MonoBehaviour
{
    
    //UI text
    
    //public TextMeshProUGUI Pickup;

    //bool to activate and diactivate script
    bool active = true;
    bool action = false;

    void Update(Interactor interactor)
    {
        var moneySystem = interactor.GetComponent<MoneySystem>();

        //sets UI elements to not active
        if (Input.GetKeyDown(KeyCode.E) && active == true && action == true)
        {
            Debug.Log("ADD MONEY PLEASE");
            moneySystem.AddMoney();
        }

      

    }

    //sets UI elemt to active when player enters
    void OnTriggerStay(Collider collision)
    {
        Debug.Log("TRIGGER!!!!!!!!!!");
        if (active == true)
        {
            //Pickup.gameObject.SetActive(true);
        }

        if (collision.transform.tag == "Player")
        {
            action = true;
        }

    }
}
