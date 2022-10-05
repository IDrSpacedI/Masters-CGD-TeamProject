using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Toggle : MonoBehaviour
{
    public bool[] toggle;
    public TextMeshProUGUI[] UIText;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            for (int i = 0; i < toggle.Length; i++)
            {
                for (int t = 0; t < UIText.Length; t++)
                {
                    if (toggle[i] == false)
                    {
                        UIText[t].gameObject.SetActive(true);
                    }
                    else if (toggle[i] == true)
                    {
                        UIText[t].gameObject.SetActive(false);
                    }
                }
            }
        }
      
    }
}
