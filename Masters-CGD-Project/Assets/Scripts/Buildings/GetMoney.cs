using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GetMoney : MonoBehaviour
{
    public int amount;
    private GameObject player;
    public bool Available;

    //public TextMeshProUGUI Pickup;

    //public MoneySystem Money;

    //bool to activate and diactivate script
    public bool action = false;

    public GameObject TextPrompt;
    public GameObject coinUI;
    public GameObject MaxCoins;

    MoneySystem money;

    private void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        GetComponent<MoneySystem>();
        Gamemanager.Instance.Object.Add(this.gameObject);
        MaxCoins.SetActive(false);
        
    }

    void Update()
    {
       if (Input.GetKeyDown(KeyCode.E) && action == true)
       {
            //Debug.Log("ADD MONEY PLEASE");          
            if(player.gameObject.GetComponent<IMoney>().addMoney(amount))
            {
                MaxCoins.SetActive(false);
                TextPrompt.SetActive(false);
                coinUI.SetActive(true);
                //FindObjectOfType<SoundManager>().PlaySound("coin");
                FindObjectOfType<SoundManager>().PlaySound("BreakTree");
                //Destroy(gameObject);
                action = false;
                this.gameObject.SetActive(false);
                Available = true;
                Invoke("respawn",Random.Range(10,15));
            }
            else
            {
                Debug.Log("Max amount reached");
                MaxCoins.SetActive(true);
                StartCoroutine(Delayv2());
            }
            
       }
      
    }
    void respawn()
    {
        //active = true;
        this.gameObject.SetActive(true);

    }
    //sets UI elemt to active when player enters
    void OnTriggerEnter(Collider collision)
    {
        //Debug.Log("TRIGGER!!!!!!!!!!");
        //if (active == true)
        //{
        //    TextPrompt.SetActive(true);
        //    //Pickup.gameObject.SetActive(true);
        //}

        if (collision.transform.tag == "Player")
        {
            //Debug.Log("touching");
            TextPrompt.SetActive(true);
            action = true;
        }

    }

    public IEnumerator Delayv2()
    {
        yield return new WaitForSeconds(2f);
        MaxCoins.SetActive(false);
    }

    public IEnumerator Delay()
    {
        yield return new WaitForSeconds(3f);
        coinUI.SetActive(false);
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
