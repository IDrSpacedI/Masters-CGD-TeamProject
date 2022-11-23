using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class FriendlyAI : MonoBehaviour
{
    public NavMeshAgent agent;
    public Transform toolShed;
    public Transform armory;

    public LayerMask whatIsGround;

    //Patroling
    public Vector3 walkPoint;
    bool walkPointSet;
    public float walkPointRange;
    bool idleNow;
    public float idleTime = 3f;

    //animation
    public Animator aiAnimation;

    private void Awake()
    {
        agent = GetComponent<NavMeshAgent>();    
    }

    // Start is called before the first frame update
    void Start()
    {
        idleNow = false;
    }

    // Update is called once per frame
    void Update()
    {
        if(idleNow == false)
        {
            Patroling();
        }
        else
        {
            aiAnimation.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
        }
    }

    void SearchWalkPoint()
    {
        //Calculate random point in range
        float randomZ = Random.Range(-walkPointRange, walkPointRange);
        float randomX = Random.Range(-walkPointRange, walkPointRange);

        walkPoint = new Vector3(transform.position.x + randomX, transform.position.y, transform.position.z);

        if (Physics.Raycast(walkPoint, -transform.up, 2f, whatIsGround))
        {
            walkPointSet = true;
        }
    }

    public void Patroling()
    {
        if (!walkPointSet) SearchWalkPoint();

        if (walkPointSet)
        {
            agent.SetDestination(walkPoint);
            
        }

        Vector3 distanceToWalkPoint = transform.position - walkPoint;

        //Walkpoint Reached
        if (distanceToWalkPoint.magnitude < 1f)
        {
            walkPointSet = false;
            idleNow = true;
            Idle();
        }

        aiAnimation.SetFloat("Speed", 1f, 0.1f, Time.deltaTime);
    }

    public void Idle()
    {
        StartCoroutine(IdleTimer());
    }

    IEnumerator IdleTimer()
    {
        
        yield return new WaitForSeconds(idleTime);
        idleNow = false;
    }
}
