using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AIenemybotctrl : MonoBehaviour
{

    public GameObject destination;
    public int life;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void Go_and_attack()
    {
         GetComponent<NavMeshAgent>().SetDestination(destination.transform.position);
    }

    public void Reduce_life()
    {
        if (life - 1 > 0)
            life -= 1;
        else
            DestroyImmediate(this.gameObject);
    }

    private void  OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag=="Player")
        {
           Debug.Log("Melvin collided something  "+other.gameObject.name);
           GetComponent<BoxCollider>().enabled = false; 
            GetComponent<NavMeshAgent>().isStopped = true;
            other.gameObject.GetComponent<IHealth>().reducehealth(1);
            Invoke("enablecollider",5f);
        }
    }

    void enablecollider()
    {
         GetComponent<NavMeshAgent>().isStopped = false;
         GetComponent<BoxCollider>().enabled = true; 
         Go_and_attack();
         
    }

}
