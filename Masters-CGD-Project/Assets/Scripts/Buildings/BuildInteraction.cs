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


    //Different level objects
    //public GameObject level1;
    //public GameObject level2;
    //public GameObject level3;

    //VFX for the objects
    //public GameObject level1FX;
    //public GameObject level2FX;
    //public GameObject level3FX;

    //Bool to let the game know which levels are build
    //public bool level1build = false;
    //public bool level2build = false;
    //public bool level3build = false;

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

        //level1.SetActive(false);
        //level2.SetActive(false);
        //level3.SetActive(false);

        //level1FX.SetActive(false);
        //level2FX.SetActive(false);
        //level3FX.SetActive(false);

        //pos = this.transform.position;
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
                finished = true;
                iLevelWall.mainUpgrade.SetActive(true);
                FindObjectOfType<SoundManager>().PlaySound("coin");
                Available = false;
            }
        }
        currentLevel++;
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
           
            if (GameObject.Find("NewBase").GetComponent<BuildInteraction>().currentLevel >= this.currentLevel)
            {
                if (moneySystem == null || Available == true || currentLevel == levels.Length - 1 || !moneySystem.spendMoney(5))
                    return false;
                Available = true;
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

//public void OnTriggerEnter(Collider other)
//{
//    if(other.gameObject.CompareTag("Builder"))
//    {

//        Available = false;

//    }
//}


/*//list of If loops, could be more better but it works now, fix later xD
if (Input.GetKey(KeyCode.E) && level1build == false && level2build == false && level3build == false)
{
    level1.SetActive(true);
    level1FX.SetActive(true);
    level1build = true;
    buildTimeLeft = buildTime;
    FindObjectOfType<SoundManager>().Play("coin");
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
}*/
