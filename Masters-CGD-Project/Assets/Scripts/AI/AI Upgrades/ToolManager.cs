using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ToolManager : MonoBehaviour
{

    private int amount;
    public int max;
    [SerializeField]private GameObject[] tools;

    private bool active = true;
    private bool action = false;
    public bool available = false;

    public GameObject TextPrompt;

    // Start is called before the first frame update
    void Start()
    {
        TextPrompt.SetActive(false);
        foreach (GameObject tool in tools)
		{
            tool.SetActive(false);
		}
    }

    // Update is called once per frame
    void Update()
    {
        if (amount < max)
        {
            active = true;
            if (Input.GetKeyDown(KeyCode.E) && active && action)
            {
                FindObjectOfType<SoundManager>().PlaySound("coin");
                AddTools(1);
            }
		}
		else
		{
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

	public void RemoveTools(int num)
	{
        int i = 0;
        GameObject[] temp = new GameObject[max];
        while (i < num)
		{
            int randomTool = Random.Range(0, max - 1);
			if (tools[randomTool].activeSelf)
			{
                tools[randomTool].SetActive(false);
                amount--;
                i++;
			}
            temp[randomTool] = tools[randomTool];
            if (temp == tools)
			{
                return;
			}
        }
    }

	//sets UI elemt to active when player enters
	void OnTriggerEnter(Collider collision)
    {
        if (active == true)
        {
            TextPrompt.SetActive(true);
        }

        if (collision.transform.tag == "Player")
        {
            //Debug.Log("touching");
            action = true;
        }
    }

    void OnTriggerExit(Collider collision)
    {
        TextPrompt.SetActive(false);
        action = false;
        if (collision == null)
        {
            TextPrompt.SetActive(false);
        }
    }
}