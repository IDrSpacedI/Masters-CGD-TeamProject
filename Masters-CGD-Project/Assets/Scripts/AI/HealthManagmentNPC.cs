using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthManagmentNPC : MonoBehaviour
{
    public int health;

    //Attack from the outside
    public void attack(int damage)
    {
        if (health - damage <= 0)
        {
            Debug.Log(this.name + " died");
            Destroy(gameObject);
            return;
        }
        health = health - damage;
        Debug.Log(this.name + " took damage; Current health: " + health);
    }
}
