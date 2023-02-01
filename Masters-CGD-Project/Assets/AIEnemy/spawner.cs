using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spawner : MonoBehaviour
{
    public GameObject enemyAI;
    float time;
    List<GameObject> enemies = new List<GameObject>();
    int enemyupdatecount,currentenemycount;
    // Start is called before the first frame update
    void Start()
    {
        currentenemycount = 3;
        enemyupdatecount = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if (enemies.Count== 0)
        {
            //if (time < 10)
            //    time += Time.deltaTime;
            //else
            //{
            currentenemycount += enemyupdatecount;
            for (int i = 0; i < currentenemycount; i++)
            {
                enemies.Add(Instantiate(enemyAI, transform.position, Quaternion.identity));
                enemies[enemies.Count - 1].GetComponent<AIenemybotctrl>().destination = Gamemanager.Instance.Enemy_Destination;
                enemies[enemies.Count - 1].GetComponent<AIenemybotctrl>().Go_and_attack();
            }
            enemyupdatecount++;
               // time = 0;
               // }
        }
        else
        {
            for (int i = 0; i < enemies.Count; i++)
                if (!enemies[i])
                    enemies.RemoveAt(i);
        }
    }
}
