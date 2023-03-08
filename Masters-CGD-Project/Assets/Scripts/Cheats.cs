using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Cheats : MonoBehaviour
{
    public LightingManager lm;
    public GameObject soldierPF;
    public GameObject builderPF;
    public GameObject peasantPF;
    public GameObject enemyPF;
    public GameObject player;
    public TextMeshProUGUI speedDebugText;
    public bool cheats = true;
    public GameObject spawner;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (cheats)
		{
            LightingAdjust();
            SpawnSoldier();
            SpawnBuilder();
            SpawnPeasant();
            SpawnEnemy();
            TimeTravel();
        }
        speedDebugText.text = "Speed: " + Time.timeScale;
    }

    void TimeTravel()
	{
        if (Input.GetKeyDown(KeyCode.PageUp))
		{
            Time.timeScale += 0.1f;
		}
        else if(Input.GetKeyDown(KeyCode.PageDown))
        {
            Time.timeScale -= 0.1f;
        }
    }

    void SpawnSoldier()
	{
        if (Input.GetKeyDown(KeyCode.K))
        {
            Instantiate(soldierPF, player.transform.position + new Vector3(0, 0, 1), Quaternion.identity);
        }
	}

    void SpawnBuilder()
    {
        if (Input.GetKeyDown(KeyCode.B))
        {
            Instantiate(builderPF, player.transform.position + new Vector3(0,0,1), Quaternion.identity);
        }
    }
    void SpawnPeasant()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            Instantiate(peasantPF, player.transform.position + new Vector3(0, 0, 1), Quaternion.identity);
        }
    }
    void SpawnEnemy()
    {
        if (Input.GetKeyDown(KeyCode.Y))
        {
            Gamemanager.Instance.totalenemies++;

            GameObject testobj = Instantiate(enemyPF, player.transform.position + new Vector3(0, 0, 1), Quaternion.identity);
            testobj.GetComponentInChildren<ChasePlayerEnemyState>().home = spawner;
            Gamemanager.Instance.gameObject.GetComponent<EntityManager>().enemyList.Add(testobj);
        }
    }

    void LightingAdjust()
	{
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            lm.speedFactor = 0.1f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            lm.speedFactor = 0.2f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            lm.speedFactor = 0.3f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha4))
        {
            lm.speedFactor = 0.4f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha5))
        {
            lm.speedFactor = 0.5f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha6))
        {
            lm.speedFactor = 0.6f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha7))
        {
            lm.speedFactor = 0.7f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha8))
        {
            lm.speedFactor = 0.8f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha9))
        {
            lm.speedFactor = 0.9f;
        }
        else if (Input.GetKeyDown(KeyCode.Alpha0))
        {
            lm.speedFactor = 1.0f;
        }
    }
}
