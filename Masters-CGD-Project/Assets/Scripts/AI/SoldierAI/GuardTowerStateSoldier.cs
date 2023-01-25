using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardTowerStateSoldier : State
{
    [SerializeField] private AttackTowerStateSoldier attackStateSoldier; 
    private GameObject enemy = null;
    [SerializeField] private Animator aiAnimation;

    public override State RunCurrentState()
    {
        aiAnimation.SetFloat("Speed", 0f, 0.5f, Time.deltaTime);
        if (enemy != null)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            attackStateSoldier.enemy = enemy;
            return attackStateSoldier;
        }
        return this;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") enemy = other.gameObject;
    }
}
