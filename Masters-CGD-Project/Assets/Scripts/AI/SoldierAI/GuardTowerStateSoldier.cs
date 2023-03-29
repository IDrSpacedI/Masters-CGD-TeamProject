using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardTowerStateSoldier : State
{
    [SerializeField] private AttackTowerStateSoldier attackStateSoldier;
    public AttackAnimationSoldier attackAnimSoldier;
    [SerializeField] private GameObject enemy = null;
    [SerializeField] private Animator aiAnimation;
    [SerializeField] private GoTowerStateSoldier goTower;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private ChooseTower chooseTower;


    public override State RunCurrentState()
    {
        aiAnimation.SetFloat("speed", 0f, 0.1f, Time.deltaTime);
        if (enemy != null)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            attackStateSoldier.enemy = enemy;
            attackAnimSoldier.enemy = enemy;

            enemy = null;
            return attackStateSoldier;
        }
        if (!goTower.tower.activeSelf)
		{
            chooseTower.removeFromSoldiers();
            goTower.navMeshAgent.enabled = true;
            return idleStateSoldier;
		}
        return this;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") enemy = other.gameObject;
    }


}
