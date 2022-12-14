using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GetMoney : MonoBehaviour
{
    public int amount;
    public GameObject player;

    //public TextMeshProUGUI Pickup;

    //public MoneySystem Money;

    //bool to activate and diactivate script
    public bool active = true;
    public bool action = false;

    public GameObject TextPrompt;

    private void Start()
    {
        GetComponent<MoneySystem>(); 
    }

    void Update()
    {
       if (Input.GetKeyDown(KeyCode.E) && active == true && action == true)
       {
            //Debug.Log("ADD MONEY PLEASE");          
            if(player.gameObject.GetComponent<IMoney>().addMoney(amount) == true)
            {
                TextPrompt.SetActive(false);
                FindObjectOfType<SoundManager>().PlaySound("coin");
                Destroy(gameObject);
            }
            else
            {
                Debug.Log("Max amount reached");
            }
            
       }
       if(this.gameObject == null)
       {
            TextPrompt.SetActive(false);
            action = false;
       }
    }

    //sets UI elemt to active when player enters
    void OnTriggerEnter(Collider collision)
    {
        //Debug.Log("TRIGGER!!!!!!!!!!");
        if (active == true)
        {
            TextPrompt.SetActive(true);
            //Pickup.gameObject.SetActive(true);
        }

        if (collision.transform.tag == "Player")
        {
            //Debug.Log("touching");
            action = true;
        }

    }

    void OnTriggerExit(Collider collision)
    {
        // Debug.Log("Exitted");
        TextPrompt.SetActive(false);
        action = false;
        if(collision == null)
        {
            TextPrompt.SetActive(false);
        }
    }
}
