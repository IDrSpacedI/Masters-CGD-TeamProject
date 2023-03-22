using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackAnimationSoldier : MonoBehaviour
{
    [SerializeField] AttackBarricadeSoldierState attackBarricadeSoldierState;
    public GameObject spear;
    public Animator anim;
    public GameObject enemy;


    private void jswordattack()
    {
        attackBarricadeSoldierState.Attack();
    }

    public void JSpearPickUp()
    {
        spear.SetActive(true);
        //bodyAim.weight = 1;
    }

    public void JSpearThrow()
    {
        spear.SetActive(false);
        //bodyAim.weight = 0;
        enemy.GetComponent<HealthManagmentNPC>().attack(10000);
    }



}
