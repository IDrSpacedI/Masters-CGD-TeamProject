using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class MoneySystem : MonoBehaviour,IMoney
{
    [SerializeField] public TextMeshProUGUI text;
    public TextMeshProUGUI DebugText;
    [SerializeField] private int currentMoney;
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
        else
        {
            currentMoney = maxMoney;
            return true;
        }
    }
    public void reduceMoney(int i)
    {
        spendMoney(i);
    }

    public void addMoney(int i)
    {
        getMoney(i);
    }
}

public interface IMoney
{
    void reduceMoney(int i);
    void addMoney(int i);
}
