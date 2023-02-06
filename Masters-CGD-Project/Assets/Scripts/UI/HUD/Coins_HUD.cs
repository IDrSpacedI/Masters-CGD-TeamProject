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
