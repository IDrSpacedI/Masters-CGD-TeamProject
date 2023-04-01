using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class HealthManagmentNPC : MonoBehaviour
{
    public int health;
    public GameObject bloodvfx;
    public EntityManager manager;
    // public int day, currentday;
    public List<GameObject> enemy;
    public GameObject thisEnemy;

    public bool removeFromList = false;

    public RagdollManager ragdollManager;
    public NavMeshAgent navMeshAgent;
    public GameObject masterObject;
    public float shrinkDelay = 3;

    //public FighterAiArraySystem fighterAiArraySystem;

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
            //Debug.Log(this.name + " died");
            //fighterAiArraySystem.RemoveFromList(thisEnemy);
            removeFromList= true;
            if (this.gameObject.tag == "Enemy")
            {
                Gamemanager.Instance.gameObject.GetComponent<EntityManager>().enemyList.Remove(this.gameObject);
                //Gamemanager.Instance.totalenemies = Gamemanager.Instance.totalenemies - 1 ;
                Gamemanager.Instance.enemieskilled++;
            }
            masterObject.gameObject.tag = "Dead"; //very important to ensure this entity is removed from any list as an active attack/defender
            navMeshAgent.enabled = false;
            ragdollManager.ActivateRagdoll();
            StartCoroutine(ShrinkDestroy()); //Notworking? :<
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

    IEnumerator ShrinkDestroy()
    {
        yield return new WaitForSeconds(shrinkDelay);
        masterObject.transform.localScale = Vector3.Lerp(masterObject.transform.localScale, new Vector3(0,0,0), Time.deltaTime * shrinkDelay);
        Destroy(masterObject, shrinkDelay);
    }
}
