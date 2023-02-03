using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthManagment : MonoBehaviour
{
    public int health;
    public bool dead = false;
    public BuildInteraction buildInteraction;  

    //Attack from the outside
    public void attack(int damage)
    {
        if (health - damage <= 0)
        {
            //TODO kill entity or deactivate it depending if it's a structure
            buildInteraction.DeUpgrade();
            dead = true;
            return;
        }
        health = health - damage;
    }
}
