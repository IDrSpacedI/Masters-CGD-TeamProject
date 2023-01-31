using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemiesInRange : MonoBehaviour
{

    //Enemies that the enemy can attack in range
    public List<GameObject> barricades;
    public List<GameObject> towers;
    public List<GameObject> AIFriendly;
    public bool playerInRange;
    void OnTriggerEnter(Collider other)
    {

        //Add Barricades
        if (other.tag == "Barricade")
        {
            barricades.Add(other.gameObject);
        }
        else if(other.tag == "Build")
        {
            towers.Add(other.gameObject);
        }
        else if(other.tag == "FriendlyNPC")
        {
            AIFriendly.Add(other.gameObject);
        }
        else if(other.tag == "Player")
        {
            playerInRange = true;
        }
    }


    void OnTriggerExit(Collider other)
    {
        barricades.Remove(other.gameObject);
        towers.Remove(other.gameObject);
        AIFriendly.Remove(other.gameObject);
        if (other.tag == "Player")
        {
            playerInRange = false;
        }
    }
}
