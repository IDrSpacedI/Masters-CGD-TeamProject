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
        //    if (enemies.Count== 0)
        //    {
        //        //if (time < 10)
        //        //    time += Time.deltaTime;
        //        //else
        //        //{
        //        currentenemycount += enemyupdatecount;
        //        for (int i = 0; i < currentenemycount; i++)
        //        {
        //            enemies.Add(Instantiate(enemyAI, transform.position, Quaternion.identity));
        //            enemies[enemies.Count - 1].GetComponent<AIenemybotctrl>().destination = Gamemanager.Instance.Enemy_Destination;
        //            enemies[enemies.Count - 1].GetComponent<AIenemybotctrl>().Go_and_attack();
        //        }
        //        enemyupdatecount++;
        //           // time = 0;
        //           // }
        //    }
        //    else
        //    {
        //        for (int i = 0; i < enemies.Count; i++)
        //            if (!enemies[i])
        //                enemies.RemoveAt(i);
        //    }
        //}


        void spawnenemies()
    {
        currentenemycount += enemyupdatecount;
        for (int i = 0; i < currentenemycount; i++)
        {
            enemies.Add(Instantiate(enemyAI, transform.position, Quaternion.identity));
        }
        Gamemanager.Instance.gameObject.GetComponent<EntityManager>().enemyList = enemies;
        enemyupdatecount++;
    }
}
