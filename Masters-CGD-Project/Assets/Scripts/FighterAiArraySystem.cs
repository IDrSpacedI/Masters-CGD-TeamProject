using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class FighterAiArraySystem : MonoBehaviour
{
    public List<GameObject> enemy;
    public int attackDamage = 100;
    public GameObject sourceObject, sourceObjectDefPos;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.G))
        {
            Debug.Log("Damagerssssssssssssss");
            DamageEnemy();
        }

        if (enemy.Count > 0)
        {
            sourceObject.transform.position = enemy[0].transform.position;
        }
        else
        {
            sourceObject.transform.position = sourceObjectDefPos.transform.position;
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Enemy"))
        {
            enemy.Add(other.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Enemy"))
        {
            enemy.Remove(other.gameObject);
        }
    }

    public void RemoveFromList(GameObject removeGameObject)
    {
        enemy.Remove(removeGameObject);
    }

    public void DamageEnemy()
    {
        if (enemy.Count != 0)
        {
            enemy[0].GetComponent<HealthManagmentNPC>().attack(attackDamage);
            if(enemy[0].GetComponent<HealthManagmentNPC>().removeFromList == true)
            {
                enemy.Remove(enemy[0]);
            }

        }
    }

}
