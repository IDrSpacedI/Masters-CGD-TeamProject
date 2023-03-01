using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AttackAnimationSoldier : MonoBehaviour
{
    [SerializeField] AttackBarricadeSoldierState attackBarricadeSoldierState;
    private void jswordattack()
    {
        attackBarricadeSoldierState.Attack();
    }
}
