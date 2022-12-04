using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class HealthSysytem : MonoBehaviour,IHealth
{
    [Header("UI")]
    public TextMeshProUGUI Debugtext;
    [Header("Health")]
    [SerializeField] public int currentHealth = 100;
    [SerializeField] private int maxHealth = 110;

    void Update()
    {
        //check();
        
        Debugtext.text = "Health" + ":" + currentHealth.ToString();
    }

    //Cant remove health if dead
    public bool removeHealth(int amount)
    {
        if(currentHealth - amount >= 0)
        {
            currentHealth = currentHealth - amount;
            return true;
        }
        else
        {
            currentHealth = 0;
            playerDead();    //Call a function if dead
            return false;
        }
    }

    //Heal only till max amount reached
    public bool addHealth(int amount)
    {
        if(currentHealth + amount <= maxHealth)
        {
            currentHealth = currentHealth + amount;
            return true;        
        }
        else
        {
            currentHealth = maxHealth;
            return true;
        }
    }

   /* public void check()
    {
        if(Input.GetMouseButtonDown(0))
        {
            removeHealth(10);
            Debug.Log("Health reduced by 10");
        }
        if(Input.GetMouseButtonDown(1))
        {
            addHealth(10);
            Debug.Log("Health added by 10");
        }
        if(Input.GetMouseButtonDown(2))
        {
            increaseMaxHealth(10);
            Debug.Log("Max Health increased by 10");
        }
    }*/

    //Function if player is dead
    public void playerDead()
    {
        Debug.Log("Player Dead");
        SceneManager.LoadScene(3);
    }

    //Fucntion to increase max health
    public void increaseMaxHealth(int amount)
    {
        maxHealth = maxHealth + amount;
        addHealth(amount);
        Debug.Log("Health increased by : "+amount);
    }

    public  void  reducehealth(int i)
    {
        removeHealth(i);
    }

     public  void  increasehealth(int i)
    {
       addHealth(i);
    }
}
public interface IHealth
{
    void  reducehealth(int i);
     void  increasehealth(int i);
}