using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChooseBarricade : MonoBehaviour
{
    public EntityManager entityManager;
    public string directionTower;
    // Start is called before the first frame update
    void Start()
    {
        entityManager = GameObject.Find("GameManager").GetComponent<EntityManager>();

    }
    public GameObject checkBarricades()
    {
        GameObject towerLeft = null;
        GameObject towerRight = null;
        //Checking if any tower in the left is available
        for (int i = 0; i < entityManager.barricadesLeft.Count; i++)
        {
            //Get tower that is furthest away (the array is ordered from closest to furthest so it's easy)
            if (entityManager.barricadesLeft[i].GetComponent<BuildInteraction>().currentLevel >= 1)
            {
                towerLeft = entityManager.barricadeList[i];
            }
        }

        //Checking if any tower in the right is available
        for (int i = 0; i < entityManager.barricadesRight.Count; i++)
        {
            //Get tower that is furthest away (the array is ordered from closest to furthest so it's easy)
            if (entityManager.barricadesRight[i].GetComponent<BuildInteraction>().currentLevel >= 1)
            {
                towerRight = entityManager.barricadeList[i];
            }
        }

        if (entityManager.barricadeSoldiersOnRight.Count >= entityManager.barricadeSoldiersOnLeft.Count && towerRight != null)
        {
            directionTower = "Right";
            return towerRight;
        }
        directionTower = "Left";
        return towerLeft;
    }

    public void addToSoldiers()
    {
        if (directionTower == "Right")
            entityManager.barricadeSoldiersOnRight.Add(gameObject);
        else
            entityManager.barricadeSoldiersOnLeft.Add(gameObject);
    }
    public void removeFromSoldiers()
    {
        if (directionTower == "Right")
            entityManager.barricadeSoldiersOnRight.Remove(gameObject);
        else
            entityManager.barricadeSoldiersOnLeft.Remove(gameObject);
    }

}