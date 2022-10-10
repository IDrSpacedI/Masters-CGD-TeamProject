using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BuildInteraction : MonoBehaviour, IInteractable
{   
    //What the prompt says
    [SerializeField] private string prompt;

    //Collider to detect player
    public Collider interactCollider;

    //The actual red circle object
    public GameObject interactButton;

    //Different level objects
    public GameObject level1;
    public GameObject level2;
    public GameObject level3;

    //VFX for the objects
    public GameObject level1FX;
    public GameObject level2FX;
    public GameObject level3FX;

    //Bool to let the game know which levels are build
    public bool level1build = false;
    public bool level2build = false;
    public bool level3build = false;

    //reference for HUD text
    public TextMeshProUGUI interactText;
    public TextMeshProUGUI buildTimerText;

    //Build Timer, needed to prevent all levels are build at once
    public float buildTime = 3f;
    public float buildTimeLeft;
    
    //Assigning the text
    public string InteractionPrompt => prompt;




    // Start is called before the first frame update
    void Start()
    {
        //Enable and disable objects
        interactButton.SetActive(true);

        level1.SetActive(false);
        level2.SetActive(false);
        level3.SetActive(false);

        level1FX.SetActive(false);
        level2FX.SetActive(false);
        level3FX.SetActive(false);

        //make sure the text are invisible
        interactText.text = "";
        buildTimerText.text = "";
    }

    // Update is called once per frame
    void Update()
    {
        //Countdown timer for the builds
        if(buildTimeLeft > 0)
        {
            buildTimeLeft -= Time.deltaTime;
            buildTimerText.text = buildTimeLeft.ToString();
        }
        else
        {
            buildTimerText.text = "";
        }


    }
    /*
    //trigger system to detect when the collider is touching the player :) old
    private void OnTriggerStay(Collider other)
    {
        //only work if the object trigger has the "Player" tag
        if (other.tag == "Player")
        {
            interactText.text = "Press E to interact";
            Debug.Log("Interact time");

            //list of If loops, could be more better but it works now, fix later xD
            if (Input.GetKey(KeyCode.E) && level1build == false && level2build == false && level3build == false)
            {
                level1.SetActive(true);
                level1FX.SetActive(true);
                level1build = true;
                buildTimeLeft = buildTime;
            }
            else if (Input.GetKey(KeyCode.E) && level1build == true && level2build == false && level3build == false && buildTimeLeft <= 0)
            {
                level2.SetActive(true);
                level2FX.SetActive(true);
                level2build = true;
                buildTimeLeft = buildTime;
            }
            else if (Input.GetKey(KeyCode.E) && level1build == true && level2build == true && level3build == false && buildTimeLeft <= 0)
            {
                level3.SetActive(true);
                level3FX.SetActive(true);
                level3build = true;
                interactButton.SetActive(false);
                interactCollider.enabled = false;
                interactText.text = "";
            }

        }
    }
    
     //make sure the text on Hud disappear after the player leaves it
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            interactText.text = "";
            Debug.Log("Interact time");
        }
    }*/


    //Function called by interactor, contains the behaviour when interacted
    public bool Interact(Interactor interactor)
    {
        Debug.Log("Interact time");

        var moneySystem = interactor.GetComponent<MoneySystem>();

        if (moneySystem == null || !moneySystem.spendMoney(5))
            return false;

        //list of If loops, could be more better but it works now, fix later xD
        if (Input.GetKey(KeyCode.E) && level1build == false && level2build == false && level3build == false)
        {
            level1.SetActive(true);
            level1FX.SetActive(true);
            level1build = true;
            buildTimeLeft = buildTime;
            return true;
        }
        else if (Input.GetKey(KeyCode.E) && level1build == true && level2build == false && level3build == false && buildTimeLeft <= 0)
        {
            level2.SetActive(true);
            level2FX.SetActive(true);
            level2build = true;
            buildTimeLeft = buildTime;
            return true;
        }
        else if (Input.GetKey(KeyCode.E) && level1build == true && level2build == true && level3build == false && buildTimeLeft <= 0)
        {
            level3.SetActive(true);
            level3FX.SetActive(true);
            level3build = true;
            interactButton.SetActive(false);
            interactCollider.enabled = false;
            interactText.text = "";
            return true;
        }
        return false;
    }
   
}