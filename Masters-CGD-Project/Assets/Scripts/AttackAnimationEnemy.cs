using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackAnimationEnemy : MonoBehaviour
{

    [SerializeField] AttackEnemyState attackEnemyState;
    [SerializeField] AttackNPCState attackNPCState;
    [SerializeField] AttackPlayerState attackPlayerState;
    public bool player = false, building = false, npc = false;

    private void jOrcAttack()
    {
        //Finding out which state called attack
        if (player)
            attackPlayerState.Attack();
        if (npc)
            attackNPCState.Attack();
        if (building)
            attackEnemyState.Attack();

    }
}
