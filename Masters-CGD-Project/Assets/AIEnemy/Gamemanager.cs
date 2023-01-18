using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gamemanager : MonoBehaviour
{

    public  GameObject Enemy_Destination;
    public bool Time_to_attac;
    public static Gamemanager Instance;
    public TimeManager timemanager;
    public int Days;
    public GameObject target;
    public bool active;

    void Awake()
    {
        Instance=this;
        DontDestroyOnLoad(this.gameObject);
    }

    public GameObject check()
    {
        if (active == true)
        {
            return target;
        }
        else
        {
            return null;
        }
    }

    public void read(GameObject building)
    {
        Debug.Log("Upgrade ready !");
        target = building;
        active = true;
    }

    public void complete()
    {
        Debug.Log("Upgrade COmplete!");
        target = null;
        active = false;
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
