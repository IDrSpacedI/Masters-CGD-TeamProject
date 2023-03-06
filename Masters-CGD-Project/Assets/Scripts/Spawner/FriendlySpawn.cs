using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FriendlySpawn : MonoBehaviour
{
    public GameObject AI;
    private int day;
    private int nextday;
    private LightingManager lm;
    [HideInInspector] public List<GameObject> peasants = new List<GameObject>();

    void Start()
    {
        lm = GameObject.FindGameObjectWithTag("GM").GetComponent<LightingManager>();
        nextday = lm.dayCount;
    }

    // Update is called once per frame
    void Update()
    {
        day = lm.dayCount;
        if (day == nextday)
        {
            nextday++;
            if (peasants.Count == 0)
			{
                SpawnPeasant(Random.Range(1, 3));
            }
        }

        foreach (GameObject peasant in peasants.ToArray())
		{
			if (peasant.GetComponent<Hiring>().hired)
			{
                peasants.Remove(peasant);
			}
		}
    }

    void SpawnPeasant(int num)
	{
        for (int i = 0; i<num; i++)
		{
            float randomX = Random.Range(-5, 5);
            Vector3 spawnPoint = new Vector3(transform.position.x + randomX, transform.position.y, transform.position.z - 3);
            var newPeasant = Instantiate(AI, spawnPoint, Quaternion.identity);
            peasants.Add(newPeasant);
        }
    }
}
