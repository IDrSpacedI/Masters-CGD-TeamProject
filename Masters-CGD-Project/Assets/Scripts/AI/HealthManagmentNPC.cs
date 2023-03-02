using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthManagmentNPC : MonoBehaviour
{
    public int health;
    public GameObject bloodvfx;
    public EntityManager manager;
    // public int day, currentday;
    public List<GameObject> enemy;

    void Start()
    {
        //manager = GameObject.Find("GameManager").GetComponent<EntitiyManager>();
        //day = manager.dayCount;

        manager = GameObject.Find("GameManager").GetComponent<EntityManager>();
        enemy = manager.enemyList;

    }

    void Update()
    {

        if(enemy == null)
        {
            health = 10;
        }
        //currentday = manager.dayCount;
        //if(day != currentday)
        //{
        //    health = 10;
        //    day = currentday;
        //}
    }

    //Attack from the outside
    public void attack(int damage)
    {
        if (health - damage <= 0)
        {
            Debug.Log(this.name + " died");
            Gamemanager.Instance.enemieskilled++;
            Destroy(gameObject);
            return;
        }
        health = health - damage;
        bloodvfx.SetActive(true);
        Invoke("disableeffect",1);
        FindObjectOfType<SoundManager>().PlaySound("NPCTakingDamage");
        Debug.Log(this.name + " took damage; Current health: " + health);
    }
    void disableeffect()
    {
        bloodvfx.SetActive(false);
    }
}
