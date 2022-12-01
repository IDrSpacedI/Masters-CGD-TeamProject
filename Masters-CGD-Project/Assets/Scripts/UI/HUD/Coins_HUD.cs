using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Coins_HUD : MonoBehaviour
{

    public int Coins;
    public Image[] Coin;
    public MoneySystem M_System;

    void Update()
    {
        if (M_System.currentMoney > Coins)
        {
            M_System.currentMoney = Coins;
        }

        for (int i = 0; i < Coin.Length; i++)
        {
            if (i < M_System.currentMoney)
            {

            }
        }
    }
}
