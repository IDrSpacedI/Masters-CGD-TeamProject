using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackAnimationSoldier : MonoBehaviour
{
    [SerializeField] AttackBarricadeSoldierState attackBarricadeSoldierState;
    public GameObject spear, sword;
    public Rigidbody rigSpear;
    public Transform handLocation, enemyLocation;
    public Animator anim;
    public GameObject enemy;

    public Vector3 enemyDistance;

    private void Update()
    {

    }


    private void jswordattack()
    {
        attackBarricadeSoldierState.Attack();
    }

    public void JSpearPickUp()
    {
        spear.SetActive(true);
        sword.SetActive(false);
        //bodyAim.weight = 1;
    }

    public void JSpearThrow()
    {
        enemyDistance = enemy.transform.position;

        spear.SetActive(false);
        sword.SetActive(false);
        //bodyAim.weight = 0;
        //enemy.GetComponent<HealthManagmentNPC>().attack(10000);
        Rigidbody spawnedSpear;



        spawnedSpear = Instantiate(rigSpear, handLocation.position, transform.rotation);
        rigSpear.velocity = new Vector3(enemyDistance.x, enemyDistance.y, enemyDistance.z);

    }



}
