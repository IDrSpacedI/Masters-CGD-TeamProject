using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.ProBuilder;

public class AttackAnimationSoldier : MonoBehaviour
{
    [SerializeField] AttackBarricadeSoldierState attackBarricadeSoldierState;
    public GameObject spear, sword;
    public Rigidbody rigSpear;

    public GameObject rigSpear2;

    public Transform handLocation, enemyLocation;
    public Animator anim;
    public GameObject enemy;
    public float spearSpeed = 2f;
    private bool moveSpear = false;

    public FighterAiArraySystem fighterAiArraySystem;

    public Vector3 enemyDistance;

    private void Update()
    {
        //if (moveSpear)
        //{
        //    Rigidbody spawnedSpear;
        //    spawnedSpear = Instantiate(rigSpear, handLocation.position, transform.rotation);
        //float speed = spearSpeed * Time.deltaTime;
        //rigSpear.transform.position = Vector3.MoveTowards(transform.position, fighterAiArraySystem.enemy[0].transform.position, speed);
        //}

        //if(moveSpear)
        //{
        //    float speed = spearSpeed * Time.deltaTime;
        //    rigSpear.transform.position = Vector3.MoveTowards(transform.position, fighterAiArraySystem.enemy[0].transform.position, speed);
        //}
    }


    private void jswordattack()
    {
        //attackBarricadeSoldierState.Attack();
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

        //enemyDistance = enemy.transform.position;

        enemyDistance = fighterAiArraySystem.enemy[0].transform.position;

        spear.SetActive(false);
        sword.SetActive(false);
        //bodyAim.weight = 0;
        fighterAiArraySystem.DamageEnemy();

        //StartCoroutine(ThrowingSpear());

        Rigidbody spawnedSpear;

        InstantiateProjectile(handLocation);

        spawnedSpear = Instantiate(rigSpear, handLocation.position, transform.rotation);
        //float speed = spearSpeed * Time.deltaTime;
        //rigSpear.transform.position = Vector3.MoveTowards(transform.position, fighterAiArraySystem.enemy[0].transform.position, speed);
        Vector3 direction = fighterAiArraySystem.enemy[0].transform.position - rigSpear.transform.position;
        direction.Normalize();

        rigSpear.AddForce(direction * 100);


        //rigSpear.velocity = new Vector3(fighterAiArraySystem.enemy[0].transform.position.x, fighterAiArraySystem.enemy[0].transform.position.y, fighterAiArraySystem.enemy[0].transform.position.z);

    }

    //IEnumerator ThrowingSpear()
    //{
    //    Rigidbody spawnedSpear;

    //    spawnedSpear = Instantiate(rigSpear, handLocation.position, transform.rotation);
    //    float speed = spearSpeed * Time.deltaTime;
    //    rigSpear.transform.position = Vector3.MoveTowards(transform.position, fighterAiArraySystem.enemy[0].transform.position, speed);
    //    yield return new WaitForSeconds(1);
    //    moveSpear = false;
    //}

    public void InstantiateProjectile(Transform firepoint)
    {
        var projectileObj = Instantiate(rigSpear2, firepoint.position, Quaternion.identity) as GameObject;
        projectileObj.GetComponent<Rigidbody>().velocity = (enemyDistance - firepoint.position).normalized * spearSpeed;
    }

}
