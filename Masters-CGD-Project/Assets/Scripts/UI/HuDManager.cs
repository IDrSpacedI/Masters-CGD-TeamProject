using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;


public class HuDManager : MonoBehaviour
{
    [Header("Toggle")]
    public bool[] toggleUI;
    [Header("UI")]
    public TextMeshProUGUI[] UIText;

    public void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            for(int i = 0; i < UIText.Length; i++)
            {
                for(int t = 0; i < toggleUI.Length; i++)
                {
                    // checks each bool in array
                    if (toggleUI[t] == false)
                    {
                        // sets all objects to inactive
                        UIText[i].gameObject.SetActive(true);
                    }
                    // // checks each bool in array
                    else if (toggleUI[t] == true)
                    {
                        // sets all objects to inactive
                        UIText[i].gameObject.SetActive(false);
                    }
                }
            }
        }
    }

    // alternative function
    public void toggle( bool UI, TextMeshProUGUI UIText)
    {
        if(UI == false)
        {
            UIText.gameObject.SetActive(true);
        }
        else if( UI == true)
        {
            UIText.gameObject.SetActive(false);
        }
        return;
    }
    


}
