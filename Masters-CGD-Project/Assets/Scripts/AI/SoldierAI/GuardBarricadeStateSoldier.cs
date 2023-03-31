using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardBarricadeStateSoldier : State
{
    [SerializeField] private GameObject enemy = null;
    [SerializeField] private AttackBarricadeSoldierState attackBarricadeSoldierState;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private LightingManager lightingManager;
    [SerializeField] private ChooseBarricade chooseBarricade;
    [SerializeField] private Animator aiAnimation;

    public GameObject barricade;
    public void Start()
    {
        lightingManager = GameObject.Find("GameManager").GetComponent<LightingManager>();
    }
    public override State RunCurrentState()
    {
       
        aiAnimation.SetFloat("speed", 0f, 0.5f, Time.deltaTime);

        //If there are enemies near the barricades
        if (barricade.GetComponent<BuildInteraction>().enmiesonattack.Count>0)
        {
            if (idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack.Count > 0)
            {
                attackBarricadeSoldierState.enemy = barricade.GetComponent<BuildInteraction>().enmiesonattack[0];
                attackBarricadeSoldierState.barricade = barricade;
                return attackBarricadeSoldierState;
            }
        }
        //If it's daytime return to base
        if (lightingManager.TimeOfDay >= 6 && lightingManager.TimeOfDay < 18)
        {
            GetComponent<CapsuleCollider>().enabled = false;
            chooseBarricade.removeFromSoldiers();
            return idleStateSoldier;
        }

        return this;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") enemy = other.gameObject;
    }
}
