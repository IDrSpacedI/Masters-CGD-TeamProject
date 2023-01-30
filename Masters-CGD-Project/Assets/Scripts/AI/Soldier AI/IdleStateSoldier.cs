using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleStateSoldier : State
{
    public EntityManager entityManager;
    [SerializeField] private GoTowerStateSoldier goTowerStateSoldier;
    [SerializeField] private GoBarricadeStateSoldier goBarricadeStateSoldier;
    [SerializeField] private LightingManager lightingManager;

    GameObject currentBarricade = null;
    float distance;

    public void Start()
    {
        entityManager = GameObject.Find("GameManager").GetComponent<EntityManager>();
        lightingManager = GameObject.Find("LightingManager").GetComponent<LightingManager>();
    }
    public override State RunCurrentState()
    {
        //Checking if any tower is available
        for (int i = 0; i < entityManager.towerList.Count; i++)
        {
            //Get the level of the wall
            GameObject currentLevel = GetTowerLevel(entityManager.towerList[i]);
            //check the numbers of slots if different from the count of the guards 
            if (currentLevel != null && currentLevel.GetComponent<LevelWall>().slots != currentLevel.GetComponent<LevelWall>().guards.Count)
            {
                //If number is different, means it's not full
                goTowerStateSoldier.tower = currentLevel;
                return goTowerStateSoldier;

            }
        }
        //If it's night, time to defend from the barricade
        if (lightingManager.TimeOfDay >= 18)
        {
            //Check for the closest barricade
            for (int i = 0; i < entityManager.barricadeList.Count; i++)
            {
                currentBarricade = CompareBarricadeDistance(entityManager.barricadeList[i]);
            }
            //If there's no barricades anywhere do nothing
            if(currentBarricade != null)
            {
                goBarricadeStateSoldier.barricade = currentBarricade;
                currentBarricade = null;
                return goBarricadeStateSoldier;
            }
        }

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
}
