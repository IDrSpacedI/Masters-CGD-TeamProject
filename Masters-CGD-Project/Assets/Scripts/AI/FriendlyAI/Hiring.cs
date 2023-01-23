using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Hiring : MonoBehaviour
{

    public bool hired;
    public TextMeshProUGUI interactText;

    // Start is called before the first frame update
    void Start()
    {
        hired = false;
        interactText = GameObject.Find("AI_Text").GetComponent<TextMeshProUGUI>();
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            //Debug.Log("NPCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");

            if (hired == false)
            {
                interactText.text = "Press E to recruit";
                if (Input.GetKey(KeyCode.E))
                {
                    interactText.text = "Hired!";
                    hired = true;
                    StartCoroutine(Text());
                }
            }


        }
    }

    public IEnumerator Text()
    {
        yield return new WaitForSeconds(2f);
        interactText.text = "";
    }

    public void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            interactText.text = "";
        }
    }
}
