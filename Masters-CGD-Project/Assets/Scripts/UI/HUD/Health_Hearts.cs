using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Health_Hearts : MonoBehaviour
{
    public HealthSysytem health;
    public int numOfHearts;

    public Image[] hearts;
    public Sprite fullHeart;
    public Sprite emptyHeart;

    void Update()
    {

        if(health.currentHealth > numOfHearts)
        {
            health.currentHealth = numOfHearts;
        }
        for(int i = 0; i< hearts.Length; i++)
        {
            if(i < health.currentHealth)
            {
                hearts[i].sprite = fullHeart;

            }
            else
            {
                hearts[i].sprite = emptyHeart;
            }

            if(i < numOfHearts)
            {
                hearts[i].enabled = true;
            }
            else
            {
                hearts[i].enabled = false;

            }
        }
    }
}
