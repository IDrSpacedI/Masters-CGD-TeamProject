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
    [SerializeField] private ChooseTower chooseTower;
    [SerializeField] private ChooseBarricade chooseBarricade;
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
        GameObject potentialTower = chooseTower.checkTowers();
        if (potentialTower != null)
        {
            goTowerStateSoldier.tower = potentialTower;
            return goTowerStateSoldier;
        }
        //If it's night, time to defend from the barricade
        if (lightingManager.TimeOfDay >= 18)
        {
            currentBarricade = chooseBarricade.checkBarricades();
            //check if there are any barricades
            if (currentBarricade != null)
            {
                goBarricadeStateSoldier.barricade = currentBarricade;
                currentBarricade = null;
                chooseBarricade.addToSoldiers();
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