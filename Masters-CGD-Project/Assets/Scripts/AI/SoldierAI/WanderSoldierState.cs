using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


public class WanderSoldierState : State
{
    public EntityManager entityManager;

    [SerializeField] private GoTowerStateSoldier goTowerStateSoldier;
    [SerializeField] private GoBarricadeStateSoldier goBarricadeStateSoldier;
    [SerializeField] private AttackBarricadeSoldierState attackBarricadeSoldierState;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private LightingManager lightingManager;
    [SerializeField] private Animator aiAnimation;

    private GameObject enemy = null;
    GameObject currentBarricade = null;
    float distance;

    public Vector3 wonderPoint;
    public float wonderRange;
    public LayerMask whatIsGround;
    public NavMeshAgent agent;
    private bool walkPointSet;
    private Vector3 walkPoint;

    // Start is called before the first frame update
    void Start()
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
        for (int i = 0; i < entityManager.towerList.Count; i++)
        {
            //Get the level of the wall
            GameObject currentLevel = GetTowerLevel(entityManager.towerList[i]);
            //check the numbers of slots if different from the count of the guards 
            if (currentLevel != null && currentLevel.GetComponent<LevelWall>().slots.Count != currentLevel.GetComponent<LevelWall>().guards.Count)
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
                if (entityManager.barricadeList[i].GetComponent<BuildInteraction>().currentLevel >= 1)
                {
                    currentBarricade = CompareBarricadeDistance(entityManager.barricadeList[i]);
                }
            }
            //If there's no barricades anywhere do nothing
            if (currentBarricade != null)
            {
                goBarricadeStateSoldier.barricade = currentBarricade;
                currentBarricade = null;
                return goBarricadeStateSoldier;
            }
        }
        aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
        //If it's already heading somewhere continue
        if (walkPointSet)
        {
            agent.SetDestination(walkPoint);
        }
        //If not, 
        else
        {
            SetWalkPoint();
        }

        Vector3 distanceToWalkPoint = transform.position - walkPoint;

        //Walkpoint Reached
        if (distanceToWalkPoint.magnitude < 1f)
        {
            walkPointSet = false;
            return idleStateSoldier;
        }

        aiAnimation.SetFloat("speed", 1f, 0.1f, Time.deltaTime);
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
    private void SetWalkPoint()
    {
        float randomX = Random.Range(-wonderRange, wonderRange);
        walkPoint = new Vector3(wonderPoint.x + randomX, transform.position.y, transform.position.z);
        if (Physics.Raycast(walkPoint, -transform.up, 2f, whatIsGround))
        {
            walkPointSet = true;
        }
    }
}