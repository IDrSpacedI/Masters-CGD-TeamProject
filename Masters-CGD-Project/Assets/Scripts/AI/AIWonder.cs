using UnityEngine;
using UnityEngine.AI;

public class AIWonder : MonoBehaviour
{
    enum AIStates
    {
        Idle,
        Wandering,
        Defend
    }

    [SerializeField]
    private NavMeshAgent agent = null;

    [SerializeField]
    private LayerMask floorMask = 0;

    private AIStates curStates = AIStates.Idle;
    private float waitTimer = 0.0f;

    private bool action = false;

    // Update is called once per frame
    void Update()
    {
        switch(curStates)
        {
            case AIStates.Idle:
                DoIdle();
                break;
            case AIStates.Wandering:
                DoWander();
                break;
            case AIStates.Defend:
                DoDefend();
                break;
            default:
                Debug.LogError("You shouldnt be here?!?!");
                break;
        }

        if (Input.GetKey(KeyCode.E) && action == true)
        {
            Debug.Log("RECRUIT AI DEFENDER");
            curStates = AIStates.Defend;
        }


    }

    private void OnTriggerEnter(Collider collision)
    {
        if (collision.transform.tag == "Player")
        {
            Debug.Log("CAN RECRUIT");
            action = true;
        }
    }

    private void DoIdle()
    {
        //AI Idle for small amount of time
        if(waitTimer > 0)
        {
            waitTimer -= Time.deltaTime;
            return;
        }

        agent.SetDestination(RandomNavSphere(transform.position, 10.0f, floorMask));
        curStates = AIStates.Wandering;
    }

    private void DoWander()
    {
        //AI wanders random range
        if (agent.pathStatus != NavMeshPathStatus.PathComplete)
            return;

        waitTimer = Random.Range(1.0f, 4.0f);
        curStates = AIStates.Idle;
    }

    private void DoDefend()
    {
        //Defend Base 

        //defends between waypoints

        //curStates = AIStates.Defend;
    }

    Vector3 RandomNavSphere(Vector3 origin, float distance, LayerMask layerMask)
    {
        Vector3 randomDirection = UnityEngine.Random.insideUnitSphere * distance;

        randomDirection += origin;

        NavMeshHit navHit;

        NavMesh.SamplePosition(randomDirection, out navHit, distance, layerMask);

        return navHit.position;
    }


}
