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
    public Animator animator;

    public void Start()
    {
        spear.SetActive(false);
        lightingManager = GameObject.Find("GameManager").GetComponent<LightingManager>();
    }

    public override State RunCurrentState()
    {
        animator.SetLayerWeight(1, 2);
        animator.SetBool("spearattack",true);

        if (enemy == null || (lightingManager.TimeOfDay >= 6 && lightingManager.TimeOfDay < 18))
        {
            guardTowerStateSoldier.GetComponent<CapsuleCollider>().enabled = true;
            animator.SetLayerWeight(0, 2);
            animator.SetBool("spearattack", false);
            return guardTowerStateSoldier;

        }

        return this;
    }


    public void JSpearPickUp()
    {
        spear.SetActive(true);
        bodyAim.weight = 1;
    }

    public void JSpearThrow()
    {
        spear.SetActive(false);
        bodyAim.weight = 0;
        enemy.GetComponent<HealthManagmentNPC>().attack(damage);
    }
}
