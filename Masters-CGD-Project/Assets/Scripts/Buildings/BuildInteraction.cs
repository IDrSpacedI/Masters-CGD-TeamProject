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

    [SerializeField] public bool baseBuilding;

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

    public GameObject notEnoughMoney;
    public GameObject baseNeedsUpgrade;
    public GameObject maxBuild;


    public List<GameObject> enmiesonattack;

    private bool playerInRange = false;

    public GameObject waitingForBuilder;

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

        if(currentLevel == 0)
        {
            levels[0].SetActive(true);

        }

        //make sure the text are invisible
        interactText.text = "";
        buildTimerText.text = "";

    }


    // Update is called once per frame
    void Update()
    {

        if (currentLevel == 3)
        {
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
        waitingForBuilder.SetActive(false);
        finished = true;
        //If it's not base turn on ghostform
        if (!baseBuilding && currentLevel != levels.Length - 1)
        {
            if (!playerInRange)
            {
                //If player is not in range put turn off ghost form
                levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(false);
            }
            else 
            {
                //If player is in range turn on and turn on texbox
                TextBox.SetActive(true);
                levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(true);
            }
        }
   
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
        //if it's last level, don't do anything when interacting
        if(currentLevel == levels.Length - 1)
        {
                return false;
        }

        var moneySystem = interactor.GetComponent<MoneySystem>();

        if(baseBuilding == false)
            
        {
           
            if (GameObject.FindWithTag("Base").GetComponent<BuildInteraction>().currentLevel >= this.currentLevel)
            {
                //if building waiting to be upgraded by builder, no prompt
                if (Available == true)
                    return false;
                //show prompt 
                if (moneySystem == null || !moneySystem.spendMoney(5))
                {
                    notEnoughMoney.SetActive(true);
                    Invoke("DisableNotEnoughMoneyPrompt", 2f);
                    TextBox.SetActive(false);
                    return false;
                }
                FindObjectOfType<SoundManager>().PlaySound("UpgradeSound");
                Available = true;
                waitingForBuilder.SetActive(true);
                CoinsUI.SetActive(true);
                TextBox.SetActive(false);
                levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(false);
            }
            else
            {
                Invoke("DisableBaseUpgradePrompt", 2f);
                baseNeedsUpgrade.SetActive(true);
                TextBox.SetActive(false);
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
            if (Building_health <= 0)
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
   //     if (other.gameObject.tag == "Player")
   //     {
   //         if (!other.gameObject.GetComponent<Interactor>().collidedobject)
   //         {
   //             other.gameObject.GetComponent<Interactor>().collidedobject = this.gameObject;
   //             TextBox.SetActive(true);
   //             levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(true);
   //         }

   //         if(Available == true)
   //         {
   //             TextBox.SetActive(false);
   //         }
   //         if(!baseBuilding && currentLevel > -1)
			//{
   //             levels[currentLevel].GetComponent<Outline>().OutlineWidth = 2;
   //         }
                
   //         playerInRange = true;
        //}
        if(other.gameObject.tag == "Enemy")
        {
            if(!enmiesonattack.Contains(other.gameObject))
            enmiesonattack.Add(other.gameObject);
        }
    }

    public void OnTriggerLeave(Collider other)
    {
        
        if (other.gameObject.tag == "Enemy")
        {        
            enmiesonattack.Remove(other.gameObject);
        }
    }

    private void DisableBaseUpgradePrompt()
    {
        //only turn on the textbox if player in range
        if (playerInRange)
        {
            TextBox.SetActive(true);
            baseNeedsUpgrade.SetActive(false);
        }
    }

    private void DisableNotEnoughMoneyPrompt()
    {
        //only turn on the textbox if player in range
        if (playerInRange)
        {
            TextBox.SetActive(true);
            notEnoughMoney.SetActive(false);
        }
    }

    private void DisableMaxBuild()
    {
        if (playerInRange)
        {
            TextBox.SetActive(true);
            maxBuild.SetActive(false);
        }
    }


    //make sure the text on Hud disappear after the player leaves it
    //private void OnTriggerExit(Collider other)
    //{

    //    if (other.tag == "Player")
    //    {
    //        if (other.gameObject.GetComponent<Interactor>().collidedobject == this.gameObject)
    //        {
    //            other.gameObject.GetComponent<Interactor>().collidedobject = null;
    //            TextBox.SetActive(false);
    //            levels[currentLevel].GetComponent<LevelWall>().ghost.SetActive(false);
    //            levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(false);
    //            CoinsUI.SetActive(false);
    //        }
    //        if (!baseBuilding && currentLevel > -1)
    //            levels[currentLevel].GetComponent<Outline>().OutlineWidth = 0;
    //        playerInRange = false;
    //    }
    //}

    public void OnEnter()
    {
        TextBox.SetActive(true);
        //If it's not max level and it's not a base building, show ghost form
        if(currentLevel != levels.Length - 1 && !baseBuilding)
        {
            levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(true);

        }
        //If building is waiting for builders or is at max level don't show textbox
        if (Available == true || currentLevel == levels.Length - 1)
        {
            TextBox.SetActive(false);
        }

        playerInRange = true;
    }

    public void OnLeave()
    {
        TextBox.SetActive(false);
        //Turn off ghost form
        if (!baseBuilding && currentLevel != levels.Length)
        {
            levels[currentLevel + 1].GetComponent<LevelWall>().ghost.SetActive(false);
        }
        playerInRange = false;

        //disable all possible textboxes 
        CoinsUI.SetActive(false);
        maxBuild.SetActive(false);
        notEnoughMoney.SetActive(false);
        baseNeedsUpgrade.SetActive(false);

    }
}

