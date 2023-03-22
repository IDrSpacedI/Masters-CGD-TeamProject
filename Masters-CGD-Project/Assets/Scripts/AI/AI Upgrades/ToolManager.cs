using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ToolManager : MonoBehaviour
{

    private int amount;
    public int max;
    [SerializeField]private GameObject[] tools;
    public GameObject player;

    private bool active = true;
    private bool action = false;
    public bool available = false;

    public GameObject TextPrompt;
    private string promptText;

    // Start is called before the first frame update
    void Start()
    {
        promptText = "Build";
        player = GameObject.FindGameObjectWithTag("Player");
        TextPrompt.SetActive(false);
        foreach (GameObject tool in tools)
		{
            tool.SetActive(false);
		}
    }

    // Update is called once per frame
    void Update()
    {
		ChangePromtText(TextPrompt, "BuildText", promptText);
		if (amount < max)
        {
            active = true;
            if (Input.GetKeyDown(KeyCode.E) && action)
            {
                if (player.gameObject.GetComponent<IMoney>().reduceMoney(5) == true)
                {
                    FindObjectOfType<SoundManager>().PlaySound("coin");
                    AddTools(1);
                }        
            }
		}
		else
		{
			promptText = "Build";
			TextPrompt.SetActive(false);
            action = false;
            active = false;
        }

        if (amount > 0)
		{
            available = true;
		}
		else
		{
            available = false;
		}
    }

    public void AddTools(int num)
	{
        int i = 0;
        foreach (GameObject tool in tools)
        {
            if (!tool.activeSelf)
			{
                tool.SetActive(true);
                amount++;
                i++;
			}
            if (i == num)
			{
                return;
			}
        }
	}

	public bool RemoveTools(int num)
	{
        int i = 0;
        bool success = false;
        GameObject[] temp = new GameObject[max];
        while (i < num)
		{
            int randomTool = Random.Range(0, max - 1);
			if (tools[randomTool].activeSelf)
			{
                tools[randomTool].SetActive(false);
                amount--;
                success = true;
                i++;
			}
            temp[randomTool] = tools[randomTool];
            if (temp == tools)
			{
                return success;
			}
        }
        return success;
    }

	//sets UI elemt to active when player enters
	void OnTriggerEnter(Collider collision)
    {
        if (collision.transform.tag == "Player")
        {
            if (active == true)
            {
                promptText = "Buy";
                TextPrompt.SetActive(true);
            }
            //Debug.Log("touching");
            action = true;
        }
    }

    void OnTriggerExit(Collider collision)
    {
		promptText = "Build";
		TextPrompt.SetActive(false);
        action = false;
        if (collision == null)
        {
			promptText = "Build";
			TextPrompt.SetActive(false);
        }
    }

    private void ChangePromtText(GameObject prompt, string textName, string newText)
    {
		foreach (Transform child in prompt.transform)
		{
			if (child.name == textName)
			{
				child.GetComponent<TextMeshProUGUI>().text = newText;
			}
		}
	}
}