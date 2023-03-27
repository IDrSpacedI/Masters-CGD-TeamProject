using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spawner : MonoBehaviour
{
    public GameObject enemyAI;
    float time;
    List<GameObject> enemies = new List<GameObject>();
    public int enemyupdatecount,currentenemycount;
    //Checks if it has spawned for the day
    bool hasSpawnedForTheDay = true;
    public EndGame endgame;
    // Start is called before the first frame update
    void Start()
    {
        currentenemycount = 0;
        enemyupdatecount = 1;
    }

    // Update is called once per frame
    void Update()
    {
        if (Gamemanager.Instance.Time_to_attac && hasSpawnedForTheDay == false)
        {
            hasSpawnedForTheDay = true;
            spawnenemies();
        }
        else if (!Gamemanager.Instance.Time_to_attac)
        {
            hasSpawnedForTheDay = false;
        }
        if (enemyupdatecount == 6 && enemies.Count == 0)
            endgame.ChangeScene();
    }


        void spawnenemies()
    {
        currentenemycount += enemyupdatecount/2;
        for (int i = 0; i < currentenemycount; i++)
        {
            Gamemanager.Instance.totalenemies++;
            var enemy = Instantiate(enemyAI, transform.position, Quaternion.identity);
            enemy.GetComponentInChildren<ChasePlayerEnemyState>().home = gameObject;
            enemies.Add(enemy);
        }
        Gamemanager.Instance.gameObject.GetComponent<EntityManager>().enemyList = enemies;
        enemyupdatecount++;
    }
}
