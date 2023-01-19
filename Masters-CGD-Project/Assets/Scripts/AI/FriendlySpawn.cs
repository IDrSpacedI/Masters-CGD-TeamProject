using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FriendlySpawn : MonoBehaviour
{
    public GameObject AI;
    private int day;
    private int nextday;
    [HideInInspector] public List<GameObject> peasants = new List<GameObject>();

    void Start()
    {
        nextday = FindObjectOfType<DaysCounter>().dayCount;
    }

    // Update is called once per frame
    void Update()
    {
        day = FindObjectOfType<DaysCounter>().dayCount;
        if (day == nextday)
        {
            SpawnPeasant();
        }
    }

    void SpawnPeasant()
	{
        peasants.Add(Instantiate(AI, transform.position, Quaternion.identity));
        peasants[peasants.Count - 1].GetComponent<FriendlyAI>().walkPoint = transform.position;
        peasants[peasants.Count - 1].GetComponent<FriendlyAI>().walkPointRange = 10;
        peasants[peasants.Count - 1].GetComponent<FriendlyAI>().walkPointRange = 2;
    }
}
