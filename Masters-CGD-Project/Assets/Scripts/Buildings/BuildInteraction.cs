using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class BuildInteraction : MonoBehaviour
{
    public Collider interactCollider;

    public GameObject interactButton;

    public GameObject level1;
    public GameObject level2;
    public GameObject level3;

    public bool level1build = false;
    public bool level2build = false;
    public bool level3build = false;

    public TextMeshProUGUI interactText;
    public TextMeshProUGUI buildTimerText;

    public float buildTime = 3f;
    public float buildTimeLeft;



    // Start is called before the first frame update
    void Start()
    {
        interactButton.SetActive(true);

        level1.SetActive(false);
        level2.SetActive(false);
        level3.SetActive(false);

        interactText.text = "";
        buildTimerText.text = "";
    }

    // Update is called once per frame
    void Update()
    {
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

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            interactText.text = "Press E to interact";
            Debug.Log("Interact time");

            if (Input.GetKey(KeyCode.E) && level1build == false && level2build == false && level3build == false)
            {
                level1.SetActive(true);
                level1build = true;
                buildTimeLeft = buildTime;
            }
            else if (Input.GetKey(KeyCode.E) && level1build == true && level2build == false && level3build == false && buildTimeLeft <= 0)
            {
                level2.SetActive(true);
                level2build = true;
                buildTimeLeft = buildTime;
            }
            else if (Input.GetKey(KeyCode.E) && level1build == true && level2build == true && level3build == false && buildTimeLeft <= 0)
            {
                level3.SetActive(true);
                level3build = true;
                interactButton.SetActive(false);
                interactCollider.enabled = false;
                interactText.text = "";
            }

        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            interactText.text = "";
            Debug.Log("Interact time");
        }
    }
    
    

}
