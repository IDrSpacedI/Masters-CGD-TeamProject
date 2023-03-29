using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChooseTower : MonoBehaviour
{
    public EntityManager entityManager;
    public string directionTower;
    private List<GameObject> towerListLeft;
    private List<GameObject> towerListRight;
    private List<GameObject> soldiersOnRight;
    private List<GameObject> soldiersOnLeft;
 


    // Start is called before the first frame update
    void Start()
    {
        entityManager = GameObject.Find("GameManager").GetComponent<EntityManager>();
        towerListLeft = entityManager.towerListLeft;
        towerListRight = entityManager.towerListRight;
        soldiersOnRight = entityManager.SoldiersOnRight;
        soldiersOnLeft = entityManager.SoldiersOnLeft;
    }

    // Update is called once per frame
    public GameObject checkTowers()
    {
        GameObject towerLeft = null;
        GameObject towerRight = null;

        //Checking if any tower in the left is available
        for (int i = 0; i < entityManager.towerListLeft.Count; i++)
        {
            //Get the level of the wall
            GameObject currentLevel = GetTowerLevel(entityManager.towerList[i]);
            //check the numbers of slots if different from the count of the guards 
            if (currentLevel != null && currentLevel.GetComponent<LevelWall>().slots.Count != currentLevel.GetComponent<LevelWall>().guards.Count)
            {
                //If number is different, means it's not full
                towerLeft = currentLevel;
            }
        }
       
        //Checking if any tower in the right is available
        for (int i = 0; i < entityManager.towerListRight.Count; i++)
        {
            //Get the level of the wall
            GameObject currentLevel = GetTowerLevel(entityManager.towerList[i]);
            //check the numbers of slots if different from the count of the guards 
            if (currentLevel != null && currentLevel.GetComponent<LevelWall>().slots.Count != currentLevel.GetComponent<LevelWall>().guards.Count)
            {
                //If number is different, means it's not full
                towerRight = currentLevel;
            }
        }
        
        if(soldiersOnRight.Count >= soldiersOnLeft.Count && towerRight != null)
        {
            directionTower = "Right";
            return towerRight;
        }
        directionTower = "Left";
        return towerLeft;
    }

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

    public void addToSoldiers()
    {
        if (directionTower == "Right")
            entityManager.SoldiersOnRight.Add(gameObject);
        else
            entityManager.SoldiersOnLeft.Add(gameObject);
    }
    public void removeFromSoldiers()
    {
        if (directionTower == "Right")
            entityManager.SoldiersOnRight.Remove(gameObject);
        else
            entityManager.SoldiersOnLeft.Remove(gameObject);
    }

}
