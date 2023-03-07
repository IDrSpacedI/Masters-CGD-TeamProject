using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class HealthSysytem : MonoBehaviour,IHealth
{
    [Header("UI")]
    public TextMeshProUGUI Debugtext;
    public GameObject damageui;
    [Header("Health")]
    [SerializeField] public int currentHealth = 100;
    [SerializeField] private int maxHealth = 110;
    public int startday, currentday;
   
    Color alpha;
    float tempvalue;
    public EntityManager manager;
    public List<GameObject> enemy;

    public GameObject heartsUI,healeffect,healpointlight;
   public bool healtheffected;

    void Start()
    {
        startday = GameObject.Find("GameManager").GetComponent<DaysCounter>().dayCount;
        manager = GameObject.Find("GameManager").GetComponent<EntityManager>();
        enemy = manager.enemyList;
    }

    void Update()
    {
        currentday = GameObject.Find("GameManager").GetComponent<DaysCounter>().dayCount;
        if (enemy.Count == 0 && healtheffected && startday != currentday)
        {
            currentHealth = maxHealth;
            healpointlight.SetActive(true);
            Invoke("disablelight", 3);
            healeffect.GetComponent<ParticleSystem>().Play();
            healtheffected = false;
            startday = currentday;
        }
        
        Debugtext.text = "Health" + ":" + currentHealth.ToString();
    }

    void disablelight()
    {
        healpointlight.SetActive(false);
    }
    //Cant remove health if dead
    public bool removeHealth(int amount)
    {
        if(currentHealth - amount >= 0)
        {
            // alpha = damageui.GetComponent<RawImage>().color;
            //alpha.a = 1;
            //damageui.GetComponent<RawImage>().color = alpha;
            // tempvalue = 0;
            //StartCoroutine(delay(.5f));
            damageui.GetComponent<Animator>().Play("damage effct");
            FindObjectOfType<SoundManager>().PlaySound("HurtPlayer");
            currentHealth = currentHealth - amount;
            healtheffected = true;
            return true;
        }
        else
        {
            FindObjectOfType<SoundManager>().PlaySound("LoseGame");
            currentHealth = 0;
            Invoke("playerDead", 1f);
            return false;
        }
    }

    //IEnumerator delay(float i)
    //{
    //    yield return new WaitForSeconds(i);
    //  //  damageui.GetComponent<RawImage>().enabled = false;
    //    tempvalue += .5f;
    //    alpha.a -= tempvalue;
    //    damageui.GetComponent<RawImage>().color = alpha;
       
    //    if (alpha.a<.5f)
    //    {
    //        alpha.a =0;
    //        damageui.GetComponent<RawImage>().color = alpha;
    //        //StopAllCoroutines();
    //    }
    //    else
    //        StartCoroutine(delay(.2f));


    //}

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
        StartCoroutine(Delay());
        removeHealth(i);
    }

     public  void  increasehealth(int i)
    {
        StartCoroutine(Delay());
        addHealth(i);

    }

    public IEnumerator Delay()
    {
        heartsUI.SetActive(true);
        yield return new WaitForSeconds(3f);
        heartsUI.SetActive(false);
    }
}
public interface IHealth
{
    void  reducehealth(int i);
     void  increasehealth(int i);
}