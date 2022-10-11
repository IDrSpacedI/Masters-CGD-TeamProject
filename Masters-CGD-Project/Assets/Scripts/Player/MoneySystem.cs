using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoneySystem : MonoBehaviour
{
    [SerializeField] private int currentMoney = 10;
    [SerializeField] private int maxMoney = 30;

    public static float playerMoney;

    private void Update()
    {
        Debug.Log(playerMoney);   
    }

    //Spend money impossible if player doesnt have enough money
    public bool spendMoney(int amount)
    {
        if (currentMoney - amount >= 0)
        {
            currentMoney = currentMoney - amount;
            return true;
        }
        return false;
    }

    //Getting money impossible if player doesnt have space in inventory
    public bool getMoney(int amount)
    {
        if (currentMoney + amount <= maxMoney)
        {
            currentMoney = currentMoney + amount;
            return true;
        }
        return false;
    }







}
