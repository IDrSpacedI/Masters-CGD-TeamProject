using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthManagment : MonoBehaviour
{
    public int health;
    public bool dead = false;

    //Attack from the outside
    public void attack(int damage)
    {
        if (health - damage <= 0)
        {
            //TODO kill entity or deactivate it depending if it's a structure
            gameObject.SetActive(false);
            dead = true;
            return;
        }
        health = health - damage;
    }
}
