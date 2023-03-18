using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GuardBarricadeStateSoldier : State
{
    [SerializeField] private GameObject enemy = null;
    [SerializeField] private AttackBarricadeSoldierState attackBarricadeSoldierState;
    [SerializeField] private IdleStateSoldier idleStateSoldier;
    [SerializeField] private LightingManager lightingManager;
    [SerializeField] private Animator aiAnimation;
    public void Start()
    {
        lightingManager = GameObject.Find("GameManager").GetComponent<LightingManager>();
    }
    public override State RunCurrentState()
    {
       
        aiAnimation.SetFloat("speed", 0f, 0.5f, Time.deltaTime);
        if (enemy != null)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            attackBarricadeSoldierState.enemy = enemy;
            return attackBarricadeSoldierState;
        }
       
        if(idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack.Count>0)
        {
            for (int i = 0; i < idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack.Count;)
                if (!idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack[0])
                    idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack.RemoveAt(0);
                else
                    i++;
            if (idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack.Count > 0)
            {
                Debug.Log("melvin enemy attack called");
                GetComponent<CapsuleCollider>().enabled = false;
                attackBarricadeSoldierState.enemy = idleStateSoldier.goBarricadeStateSoldier.barricade.GetComponent<BuildInteraction>().enmiesonattack[0];
                return attackBarricadeSoldierState;
            }
        }
        if (lightingManager.TimeOfDay >= 6 && lightingManager.TimeOfDay < 18)
        {
            //turn off the collision detection
            GetComponent<CapsuleCollider>().enabled = false;
            return idleStateSoldier;
        }

        return this;
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy") enemy = other.gameObject;
    }
}
