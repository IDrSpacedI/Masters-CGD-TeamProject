using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleStateSoldier : State
{
    public EntityManager entityManager;
    [SerializeField] private GoTowerStateSoldier goTowerStateSoldier;
    [SerializeField] public GoBarricadeStateSoldier goBarricadeStateSoldier;
    [SerializeField] private AttackBarricadeSoldierState attackBarricadeSoldierState;
    [SerializeField] private WanderSoldierState wanderSoldierState;
    [SerializeField] private ChooseTower chooseTower;
    [SerializeField] private LightingManager lightingManager;
    [SerializeField] private Animator aiAnimation;

    [SerializeField] private GameObject enemy = null;
   public GameObject currentBarricade = null;
    float distance;

    public void Start()
    {
        entityManager = GameObject.Find("GameManager").GetComponent<EntityManager>();
        lightingManager = GameObject.Find("GameManager").GetComponent<LightingManager>();
    }
    public override State RunCurrentState()
    {
        //If there are any enemies in range
        if (enemy != null)
        {
            //Attack
            attackBarricadeSoldierState.idle = true;
            attackBarricadeSoldierState.enemy = enemy;
            enemy = null;
            return attackBarricadeSoldierState;
        }

        //Checking if any tower is available
        GameObject potentialTower = chooseTower.checkTowers();
        if (potentialTower != null)
        {
            goTowerStateSoldier.tower = potentialTower;
            return goTowerStateSoldier;
        }
        //If it's night, time to defend from the barricade
        if (lightingManager.TimeOfDay >= 18)
        {
            //Check for the closest barricade
            for (int i = 0; i < entityManager.barricadeList.Count; i++)
            {
                if (entityManager.barricadeList[i].GetComponent<BuildInteraction>().currentLevel >= 1)
                {
                    currentBarricade = CompareBarricadeDistance(entityManager.barricadeList[i]);
                }
            }
            //If there's no barricades anywhere do nothing
            if(currentBarricade != null)
            {
                goBarricadeStateSoldier.barricade = currentBarricade;
                currentBarricade = null;
                return goBarricadeStateSoldier;
            }
        }

        aiAnimation.SetFloat("speed", 0f, 0.1f, Time.deltaTime);
        return wanderSoldierState;
        //TODO WANDER 
        return this;
    }




    //------------------------------------------------------
    
    //Get the current level of the tower to check slots
    private GameObject GetTowerLevel(GameObject tower)
    {
        int level = tower.GetComponent<BuildInteraction>().currentLevel;
        
        //if it's not level 0 (meaning nothing)
        if (level != -1)
        {   
           //return current level
           return tower.GetComponent<BuildInteraction>().levels[level];
        }
        return null;
    }

    private GameObject CompareBarricadeDistance(GameObject tempBarricade)
    {
        if (currentBarricade == null || Vector3.Distance(this.transform.position, tempBarricade.transform.position) < distance)
        {
            return tempBarricade;
        }
        return currentBarricade;
    }

     void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") 
            enemy = other.gameObject;
    }
}
