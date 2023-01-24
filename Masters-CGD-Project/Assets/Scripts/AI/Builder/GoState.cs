using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoState : State
{
    public GameObject target;
    public Transform _target;
    public float _speed;
    public IdleState I_state;

    public override State RunCurrentState()
    {
        if(I_state.Move == true)
        {
            target = Gamemanager.Instance.tower;
            _target = target.transform;
            transform.position = Vector3.MoveTowards(transform.position, _target.position, _speed * Time.deltaTime);
        }
        

        //Move code here

        return this;
    }
}
