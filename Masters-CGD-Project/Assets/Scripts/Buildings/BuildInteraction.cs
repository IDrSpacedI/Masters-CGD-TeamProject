using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BuildInteraction : MonoBehaviour, IInteractable,IHealth
{   
    //What the prompt says
    [SerializeField] private string prompt;

    [SerializeField] public GameObject[] levels;

    [SerializeField] public int currentLevel = -1;

    [SerializeField] public bool basebuilding;

    //[SerializeField] private GameObject BaseBuilding;


    //Collider to detect player
    public Collider interactCollider;

    //The actual red circle object
    public GameObject interactButton;

    //reference for HUD text
    public TextMeshProUGUI interactText;
    public TextMeshProUGUI buildTimerText;

    //Build Timer, needed to prevent all levels are build at once
    public float buildTime = 3f;
    public float buildTimeLeft;

    //public GameObject gamemanager;
    //static public Vector3 pos;

    //Assigning the text
    public string InteractionPrompt => prompt;

    public bool finished;
    public bool Available;

    public int Building_health=10;

    public GameObject upgradeTent;

    public GameObject TextBox;

    public GameObject CoinsUI;
    public Animation coins;


    // Start is called before the first frame update
    void Start()
    {
        Gamemanager.Instance.Object.Add(this.gameObject);
        //Enable and disable objects
        interactButton.SetActive(true);

        //gamemanager = GameObject.Find("GameManager");


        for (int i = 0; i < levels.Length; i++)
        {
            levels[i].SetActive(false);
        }

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

        if (currentLevel == 3)
        {
            //TextBox.SetActive(false);
            interactButton.SetActive(false);
            //Destroy(interactButton);
            //Destroy(TextBox);
        }

    }
    
    //Changes which object is active in the image (current level is always -1 the real level)
    public void Upgrade()
    {
        FindObjectOfType<SoundManager>().PlaySound("BuildingSound");
        finished = false;
        for (int i = 0; i < levels.Length; i++)
        {
            //Sets current level inactive
            if (i == currentLevel)
                levels[i].SetActive(false);
            else if (i == currentLevel + 1)
            {
                //sets the next level to active and activate the FX and the main building for animation
                levels[i].SetActive(true);
                LevelWall iLevelWall = levels[i].GetComponent<LevelWall>();
                iLevelWall.levelFX.SetActive(true);
                iLevelWall.levelFX.GetComponent<ParticleSystem>().Play();
                iLevelWall.mainUpgrade.SetActive(true);
                FindObjectOfType<SoundManager>().PlaySound("coin");
                Available = false;
            }
        }
        currentLevel++;
    }

    public void AnimationEnd()
    {
        finished = true;
        //If it's not base allow 
        if (!basebuilding)
            levels[currentLevel].GetComponent<Outline>().enabled = true;
        
    }

    public void DeUpgrade()
    {
        for (int i = 0; i < levels.Length; i++)
        {
            LevelWall iLevelWall;
            //Deactivates currentLevel
            if (i == currentLevel)
            {
                levels[i].SetActive(false);
                iLevelWall = levels[i].GetComponent<LevelWall>();
                iLevelWall.levelFX.SetActive(true);
                iLevelWall.levelFX.GetComponent<ParticleSystem>().Play();
            }
            else if (i == 0)
            {
                //sets the next level to active and activate the FX and the main building for animation
                levels[i].SetActive(true);
                iLevelWall = levels[i].GetComponent<LevelWall>();
                iLevelWall.levelFX.SetActive(true);
                iLevelWall.mainUpgrade.SetActive(true);

                //TODO play different sound

                //FindObjectOfType<SoundManager>().PlaySound("coin");
            }
        }
        currentLevel = 0;
    }
    //Function called by interactor, contains the behaviour when interacted
    public bool Interact(Interactor interactor)
    {
        //Debug.Log("Interact time");

        var moneySystem = interactor.GetComponent<MoneySystem>();

        if(basebuilding == false)
            
        {
           
            if (GameObject.FindWithTag("Base").GetComponent<BuildInteraction>().currentLevel >= this.currentLevel)
            {
                //GameObject.Find("---NewBase---").GetComponent<BuildInteraction>().currentLevel
                if (moneySystem == null || Available == true || currentLevel == levels.Length - 1 || !moneySystem.spendMoney(5))
                    return false;
                FindObjectOfType<SoundManager>().PlaySound("UpgradeSound");
                Available = true;
                CoinsUI.SetActive(true);
            }
            else
            {
                Debug.Log("Base Building needs to be upgraded");
            }
        }
        else
        {
            //if (moneySystem == null || currentLevel == levels.Length - 1)
            //    return false;
            //if (currentLevel == -1)
            //{
            //    upgradeTent.SetActive(true);
            //    if(moneySystem.reduceMoney(5) == true)
            //    {
            //        Upgrade();
            //    }   
            //}
            if (moneySystem == null || currentLevel == levels.Length - 1 || !moneySystem.spendMoney(5))
                return false;
            if (currentLevel == -1)
            {
                upgradeTent.SetActive(true);
            }
            Upgrade();
        }

        return true;
    }

    public void reducehealth(int i)
    {
        if (currentLevel >=0)
        {
            Building_health-=i;
            if (Building_health == 0)
            {
                currentLevel = -1;
                for (int j = 0; j < levels.Length; j++)
                    levels[j].SetActive(false);
            }
        }
    }

    public void increasehealth(int i)
    {
       // throw new System.NotImplementedException();
    }


    public void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag == "Player")
        {
            if (!other.gameObject.GetComponent<Interactor>().collidedobject)
            {
                other.gameObject.GetComponent<Interactor>().collidedobject = this.gameObject;
                TextBox.SetActive(true);
            }

            if(Available == true)
            {
                TextBox.SetActive(false);
            }
            if(!basebuilding && currentLevel > -1)
                levels[currentLevel].GetComponent<Outline>().OutlineWidth = 2;
        }
    }


    //make sure the text on Hud disappear after the player leaves it
    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            if (other.gameObject.GetComponent<Interactor>().collidedobject==this.gameObject)
            {
                other.gameObject.GetComponent<Interactor>().collidedobject =null;
                TextBox.SetActive(false);
                Debug.Log("Interact time");
                CoinsUI.SetActive(false);
            }
            if (!basebuilding && currentLevel > -1)
                levels[currentLevel].GetComponent<Outline>().OutlineWidth = 0;
        }
    }

}

