using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Animations.Rigging;

public class AttackTowerStateSoldier : State
{
    public GameObject enemy;
    [SerializeField] private GuardTowerStateSoldier guardTowerStateSoldier;

    //Damage and time between attacks
    [SerializeField] private int damage;
    public float elapsedTime;
    [SerializeField] private float TimeAttack;
    [SerializeField] private LightingManager lightingManager;
    public GameObject spear;
    public MultiAimConstraint bodyAim;

    public void Start()
    {
        spear.SetActive(false);
        lightingManager = GameObject.Find("GameManager").GetComponent<LightingManager>();
    }

    public override State RunCurrentState()
    {
        if (enemy == null || (lightingManager.TimeOfDay >= 6 && lightingManager.TimeOfDay < 18))
            return guardTowerStateSoldier;

        if (elapsedTime >= TimeAttack)
        {
            //Attack enemy
            Debug.Log("attack");
            enemy.GetComponent<HealthManagmentNPC>().attack(damage);
            elapsedTime = 0f;
        }

        return this;
    }


    public void JSpearPickUp()
    {
        spear.SetActive(true);
        bodyAim.weight = 1;
    }

    public void JSpearAttack()
    {
        spear.SetActive(false);
        bodyAim.weight = 0;
    }
}
