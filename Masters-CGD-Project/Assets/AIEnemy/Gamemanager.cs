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
    //public Vector3 towerposition;
    [SerializeField] public ArrayList Objects = new ArrayList();

    void Awake()
    {
        Instance=this;
        DontDestroyOnLoad(this.gameObject);
        //towerposition = Vector3.zero;
        Objects = new ArrayList();

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
