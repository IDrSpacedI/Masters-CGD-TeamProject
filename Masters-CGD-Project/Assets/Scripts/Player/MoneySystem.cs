using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class MoneySystem : MonoBehaviour,IMoney
{
    [SerializeField] public TextMeshProUGUI text;
    public TextMeshProUGUI DebugText;
    [SerializeField] public int currentMoney;
    [SerializeField] private int maxMoney = 30;

    //public static float playerMoney;

    void Update()
    {
        text.text = currentMoney.ToString();
        DebugText.text = "Coins" + ":" + currentMoney.ToString();
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
            Debug.Log("Money Added : "+amount);
            return true;
        }
        if(currentMoney == maxMoney)
        {
            return false;
        }
        else
        {
            currentMoney = maxMoney;
            return true;
        }
    }
    public bool reduceMoney(int i)
    {
        if (spendMoney(i) == true)
            return true;
        else
            return false;
    }

    public bool addMoney(int i)
    {
        if (getMoney(i) == true)
            return true;
        else
            return false;
    }
}

public interface IMoney
{
    bool reduceMoney(int i);
    bool addMoney(int i);
}
