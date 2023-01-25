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
            nextday++;
            SpawnPeasant();
        }
    }

    void SpawnPeasant()
	{
        float randomX = Random.Range(-5, 5);
        Vector3 spawnPoint = new Vector3(transform.position.x + randomX, transform.position.y, transform.position.z - 3);
        var newPeasant = Instantiate(AI, spawnPoint, Quaternion.identity);
        peasants.Add(newPeasant);
    }
}
