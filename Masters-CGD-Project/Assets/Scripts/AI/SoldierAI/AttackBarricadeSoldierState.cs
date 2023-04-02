using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackBarricadeSoldierState : State
{
    public GameObject enemy;
    public bool idle = false;
    public GameObject barricade;

    [SerializeField] private int damage;

    [SerializeField] private Animator aiAnimation;

    [SerializeField] private GuardBarricadeStateSoldier guardBarricadeStateSoldier;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private LightingManager lightingManager;

    public FighterAiArraySystem fighterAiArraySystem;

    public void Start()
    {
        lightingManager = GameObject.Find("GameManager").GetComponent<LightingManager>();
    }
    public override State RunCurrentState()
    {
        //Set attack animation on
        aiAnimation.SetLayerWeight(1, 1);
        aiAnimation.SetBool("attack", true);
        //If enemy is dead or it's daytime, turn off animation
        if (enemy == null || (lightingManager.TimeOfDay >= 6 && lightingManager.TimeOfDay < 18 && idle == false))
        {
            aiAnimation.SetBool("attack", false);
            //barricade.GetComponent<BuildInteraction>().enmiesonattack.Remove(enemy);
            aiAnimation.SetLayerWeight(1, 0);
            //If it came from idle, go back to idle
            if (idle == true)
            {
                idle = false;
                return idleStateSoldier;
            }
            //if not, continue guarding
            return guardBarricadeStateSoldier;
        }
        return this;
    }
    public void Attack()
    {
        FindObjectOfType<SoundManager>().PlaySound("AttackNPC");
        enemy.GetComponent<HealthManagmentNPC>().attack(damage);
    }
}
