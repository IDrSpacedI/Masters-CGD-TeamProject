using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class SimpleAI1 : MonoBehaviour
{
    //refeence to the nav mesh agent, player location and player health script to access to player health variable
    private NavMeshAgent navAgent;
    private Transform player;
    //PlayerHealth playerHealth;

    public LayerMask whatIsGround;
    public LayerMask whatIsPlayer;

    //Patroling
    private Vector3 walkPoint;
    bool walkPointSet;
    public float walkPointRange;

    //Attacking
    public float timeBetweenAttacks;
    bool alreadyAttacked;

    //States
    public float sightRange, attackRange;
    private bool playerInSightRange, playerInAttackRange;

    private Animator aiAnimation;

    private bool keepAttack;

    private void Awake()
    {
        //get player health script
        //playerHealth = GameObject.Find("Player").GetComponent<PlayerHealth>();
    }

    void Start()
    {
        //Get player location
        player = GameObject.Find("@@@ Player @@@").transform;
        navAgent = GetComponent<NavMeshAgent>();
        aiAnimation = GetComponent<Animator>();



        keepAttack = false;
    }

    void Update()
    {
        //Check for sight and attack range
        playerInSightRange = Physics.CheckSphere(transform.position, sightRange, whatIsPlayer);
        playerInAttackRange = Physics.CheckSphere(transform.position, attackRange, whatIsPlayer);

        //if (!playerInSightRange && !playerInAttackRange)
        //{
        //    Patroling();
        //}

        //if (playerInSightRange && !playerInAttackRange)
        //{
        //    ChasePlayer();
        //}
        //move to player location
        ChasePlayer();

        //Attack player when in range
        if (playerInAttackRange && playerInSightRange)
        {
            AttackPlayer();
        }

        if (keepAttack == true)
        {
            aiAnimation.SetBool("Punch", true);
        }
        else
        {
            aiAnimation.SetBool("Punch", false);
        }

    }

    
    //Partol function used at the beginnning but not used later on
    public void Patroling()
    {
        if (!walkPointSet) SearchWalkPoint();

        if (walkPointSet)
        {
            navAgent.SetDestination(walkPoint);
        }

        Vector3 distanceToWalkPoint = transform.position - walkPoint;

        //Walkpoint Reached
        if (distanceToWalkPoint.magnitude < 1f)
        {
            walkPointSet = false;
        }
        keepAttack = false;

        aiAnimation.SetFloat("ZombieSpeed", 1f, 0.1f, Time.deltaTime);
        //enemyAnimator.SetFloat("y", 0.5f, 0.1f, Time.deltaTime);
    }

    //used for patroling but no longer used
    void SearchWalkPoint()
    {
        //Calculate random point in range
        float randomZ = Random.Range(-walkPointRange, walkPointRange);
        float randomX = Random.Range(-walkPointRange, walkPointRange);

        walkPoint = new Vector3(transform.position.x + randomX, transform.position.y, transform.position.z + randomZ);

        if (Physics.Raycast(walkPoint, -transform.up, 2f, whatIsGround))
        {
            walkPointSet = true;
        }
        keepAttack = false;
    }

    //Go to player location
    public void ChasePlayer()
    {
        navAgent.SetDestination(player.position);

        //aiAnimation.SetFloat("ZombieSpeed", 1f, 0.1f, Time.deltaTime);

        aiAnimation.SetBool("Sprint", true);
        aiAnimation.SetBool("Punch", false);

        keepAttack = false;
        //enemyAnimator.SetFloat("y", 0.5f, 0.1f, Time.deltaTime);
    }

    //Attach the player
    public void AttackPlayer()
    {
        //attack player animation
        //aiAnimation.SetFloat("ZombieSpeed", 0f, 0.1f, Time.deltaTime);
        aiAnimation.SetBool("Sprint", false);
        aiAnimation.SetBool("Punch", true);
         
        //Make sure enemy doesn't move
        navAgent.SetDestination(transform.position);

        Vector3 targetPosition = new Vector3(player.transform.position.x, transform.position.y, player.transform.position.z);
        transform.LookAt(targetPosition);

        //playerHealth.TakeDamage();

        if (!alreadyAttacked)
        {
            //Attack code here
            alreadyAttacked = true;
            Invoke(nameof(ResetAttack), timeBetweenAttacks);
        }
        keepAttack = true;
    }

    void ResetAttack()
    {
        alreadyAttacked = false;
    }

    //used to visuilz patrol range
    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, attackRange);
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, sightRange);
    }

    //Attack funciton called in animation event setting, dealing damage
    private void ZAttack()
    {
        //playerHealth.TakeDamage();

    }
}
