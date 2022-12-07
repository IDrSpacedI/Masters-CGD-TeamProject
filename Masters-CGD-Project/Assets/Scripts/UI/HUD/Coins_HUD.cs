using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Coins_HUD : MonoBehaviour
{
    [Header("Int reference")]
    public int Coins;
    [Header("array reference")]
    public GameObject[] Coin;
    [Header("money system")]
    public MoneySystem M_System;
    private int MaxMoney;
    private int i;

    void Start()
    {
        MaxMoney = M_System.maxMoney;
        Coins = M_System.currentMoney;
        for (i = 0; i < Coins; i++)
        {
            Coin[i].SetActive(true);
        }
        for (; i < MaxMoney; i++)
        {
            Coin[i].SetActive(false);
        }
    }

    void Update()
    {
        // checks how many coins there are and corresponds with UI

        Coins = M_System.currentMoney;
            for (i = 0; i < Coins; i++)
            {
                Coin[i].SetActive(true);
            }
            for (; i < MaxMoney; i++)
            {
                Coin[i].SetActive(false);
            }

        /*if(Coins == 0)
        {
            Coin[0].gameObject.SetActive(false);
            Coin[1].gameObject.SetActive(false);
            Coin[2].gameObject.SetActive(false);
            Coin[3].gameObject.SetActive(false);
            Coin[4].gameObject.SetActive(false);
            Coin[5].gameObject.SetActive(false);
        }
        if(Coins == 5)
        {
            Coin[0].gameObject.SetActive(true);
            Coin[1].gameObject.SetActive(false);
            Coin[2].gameObject.SetActive(false);
            Coin[3].gameObject.SetActive(false);
            Coin[4].gameObject.SetActive(false);
            Coin[5].gameObject.SetActive(false);

        }
        if(Coins == 10)
        {
            Coin[0].gameObject.SetActive(true);
            Coin[1].gameObject.SetActive(true);
            Coin[2].gameObject.SetActive(false);
            Coin[3].gameObject.SetActive(false);
            Coin[4].gameObject.SetActive(false);
            Coin[5].gameObject.SetActive(false);

        }
        if (Coins == 15)
        {
            Coin[0].gameObject.SetActive(true);
            Coin[1].gameObject.SetActive(true);
            Coin[2].gameObject.SetActive(true);
            Coin[3].gameObject.SetActive(false);
            Coin[4].gameObject.SetActive(false);
            Coin[4].gameObject.SetActive(false);
            Coin[5].gameObject.SetActive(false);

        }
        if (Coins == 20)
        {
            Coin[0].gameObject.SetActive(true);
            Coin[1].gameObject.SetActive(true);
            Coin[2].gameObject.SetActive(true);
            Coin[3].gameObject.SetActive(true);
            Coin[4].gameObject.SetActive(false);
            Coin[4].gameObject.SetActive(false);
            Coin[5].gameObject.SetActive(false);

        }
         if (Coins == 25)
         {
            Coin[0].gameObject.SetActive(true);
            Coin[1].gameObject.SetActive(true);
            Coin[2].gameObject.SetActive(true);
            Coin[4].gameObject.SetActive(true);
            Coin[5].gameObject.SetActive(false);

         }

         if( Coins == 30)
         {
            Coin[0].gameObject.SetActive(true);
            Coin[1].gameObject.SetActive(true);
            Coin[2].gameObject.SetActive(true); 
            Coin[4].gameObject.SetActive(true);
            Coin[5].gameObject.SetActive(true);
         }*/



    }  

    public void check()
    {
        Debug.Log("Check called");
        for (i = 0; i < Coins; i++)
        {
            Coin[i].SetActive(true);
        }
        for (; i < MaxMoney; i++)
        {
            Coin[i].SetActive(false);
        }
    }
    

}
