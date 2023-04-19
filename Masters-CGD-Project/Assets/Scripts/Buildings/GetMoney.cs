using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class GetMoney : MonoBehaviour, IInteractable
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
    public Outline outline;

    public bool inRange = false;
   

    MoneySystem money;

    public string InteractionPrompt => throw new System.NotImplementedException();

    private void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        GetComponent<MoneySystem>();
        Gamemanager.Instance.Object.Add(this.gameObject);
        MaxCoins.SetActive(false);
        
    }

    void Update()
    {
       //if (Input.GetKeyDown(KeyCode.E) && action == true)
       //{
       //     //Debug.Log("ADD MONEY PLEASE");          
       //     if(player.gameObject.GetComponent<IMoney>().addMoney(amount))
       //     {
       //         MaxCoins.SetActive(false);
       //         TextPrompt.SetActive(false);
       //         coinUI.SetActive(true);
       //         //FindObjectOfType<SoundManager>().PlaySound("coin");
       //         FindObjectOfType<SoundManager>().PlaySound("BreakTree");
       //         //Destroy(gameObject);
       //         action = false;
       //         player.gameObject.GetComponent<Interactor>().collidedobject = null;
       //         this.gameObject.SetActive(false);
       //         Available = true;
       //         Invoke("respawn",Random.Range(10,15));
       //     }
       //     else
       //     {
       //         Debug.Log("Max amount reached");
       //         MaxCoins.SetActive(true);
       //         StartCoroutine(Delayv2());
       //     }
            
       //}
      
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
        ////    TextPrompt.SetActive(true);
        ////    //Pickup.gameObject.SetActive(true);
        ////}

        //if (collision.transform.tag == "Player")
        //{
        //    if (!collision.gameObject.GetComponent<Interactor>().collidedobject)
        //    {
        //        collision.gameObject.GetComponent<Interactor>().collidedobject = this.gameObject;
        //        //Debug.Log("touching");
        //        TextPrompt.SetActive(true);
        //        action = true;
        //    }
        //}

    }

    public IEnumerator Delayv2()
    {
        yield return new WaitForSeconds(2f);
        MaxCoins.SetActive(false);
        if (inRange)
        {
            TextPrompt.SetActive(true);
        }
    }

    public IEnumerator Delay()
    {
        yield return new WaitForSeconds(3f);
        coinUI.SetActive(false);
    }

    //void OnTriggerExit(Collider collision)
    //{
    //    // Debug.Log("Exitted");
    //    if (collision.gameObject.GetComponent<Interactor>().collidedobject == this.gameObject)
    //    {
    //        collision.gameObject.GetComponent<Interactor>().collidedobject = null;
    //        //Debug.Log("touching");
    //        TextPrompt.SetActive(false);
    //        action = false;
    //    }
    //    if (collision == null)
    //    {
    //        TextPrompt.SetActive(false);
    //    }
    //}

    public bool Interact(Interactor interactor)
    {
        if (player.gameObject.GetComponent<IMoney>().addMoney(amount))
        {
            MaxCoins.SetActive(false);
            TextPrompt.SetActive(false);
            coinUI.SetActive(true);
            //FindObjectOfType<SoundManager>().PlaySound("coin");
            FindObjectOfType<SoundManager>().PlaySound("BreakTree");
            //Destroy(gameObject);
            action = false;
            this.gameObject.SetActive(false);
            Invoke("respawn", Random.Range(10, 15));
            return true;
        }
        else
        {
            Debug.Log("Max money reached");
            MaxCoins.SetActive(true);
            TextPrompt.SetActive(false);
            StartCoroutine(Delayv2());
            return false;
        }
    }

    public void OnEnter()
    {
        TextPrompt.SetActive(true);
        outline.OutlineWidth = 2;
        inRange = true;
    }

    public void OnLeave()
    {
        inRange = false;
        MaxCoins.SetActive(false);
        TextPrompt.SetActive(false);
        outline.OutlineWidth = 0;

    }
}
