using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GetMoney : MonoBehaviour
{
    
    //UI text
    
    //public TextMeshProUGUI Pickup;

    //bool to activate and diactivate script
    public bool active = true;
    public bool action = false;

    private void Update()
    {
        //add money and destroys plant on E Press
        if (Input.GetKey(KeyCode.E) && active == true && action == true)
        {
            Debug.Log("ADD MONEY PLEASE");
            MoneySystem.playerMoney += 10;
            Destroy(gameObject);
        }
    }

    //sets UI elemt to active when player enters
    void OnTriggerEnter(Collider collision)
    {
        Debug.Log("TRIGGER!!!!!!!!!!");
        if (active == true)
        {
            //Pickup.gameObject.SetActive(true);
        }

        if (collision.transform.tag == "Player")
        {
            Debug.Log("touching");
            action = true;
        }

    }
}
