using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class spawner : MonoBehaviour
{
    public GameObject enemyAI;
    float time;
    List<GameObject> enemies = new List<GameObject>();
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Gamemanager.Instance.Time_to_attac)
        {
            if (time < 5)
                time += Time.deltaTime;
            else
            {
                enemies.Add(Instantiate(enemyAI, transform.position, Quaternion.identity));
                enemies[enemies.Count - 1].GetComponent<AIenemybotctrl>().destination = Gamemanager.Instance.Enemy_Destination;
                enemies[enemies.Count - 1].GetComponent<AIenemybotctrl>().Go_and_attack();
                time = 0;
            }
        }
    }
}
