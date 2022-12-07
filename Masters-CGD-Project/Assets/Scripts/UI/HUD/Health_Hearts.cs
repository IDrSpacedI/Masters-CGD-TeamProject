using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Health_Hearts : MonoBehaviour
{
    [Header("Health Reference")]
    public HealthSysytem health;
    [Header("Num of hearts")]
    public int numOfHearts;
    [Header("Sprite Reference")]
    public Image[] hearts;
    public Sprite fullHeart;
    public Sprite emptyHeart;

    void Update()
    {
        // checks is current health is greater than num of hearts
        if (health.currentHealth > numOfHearts)
        {
            health.currentHealth = numOfHearts;
        }
        // loops through hearts array
        for (int i = 0; i < hearts.Length; i++)
        {
            // checks if i is greater than current health
            if (i < health.currentHealth)
            {
                // hearts will be full hearts
                hearts[i].sprite = fullHeart;

            }
            else
            {
                // if not hearts will be empty
                hearts[i].sprite = emptyHeart;
            }
            // if hearts are less than i
            if (i < numOfHearts)
            {
                // hearts are enabled
                hearts[i].enabled = true;
            }
            else
            {
                // hearts disabled
                hearts[i].enabled = false;

            }
        }
        // checks how many hearts there are
        if(numOfHearts == 0)
        {
            health.playerDead();
        }
        //health test
        if (Input.GetKeyDown(KeyCode.F))
        {
            health.reducehealth(1);

        }
    }

}
