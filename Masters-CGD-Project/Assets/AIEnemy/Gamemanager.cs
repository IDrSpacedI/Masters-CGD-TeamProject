using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Gamemanager : MonoBehaviour
{
    public GameObject Enemy_Destination;
    public bool Time_to_attac;
    public static Gamemanager Instance;
    public TimeManager timemanager;
    public int Days;
    public GameObject toolRef;
    public GameObject armRef;
    public GameObject TextBox;
    public GameObject HiredBox;
    public GameObject mainBase;
    public ArrayList Object = new ArrayList();
    //public GameObject gameWinUI;
    public int totalrecruits, totalmoneyspend,totalsoldires,totalbuilders,totalenemies,enemieskilled;
void Awake()
    {
        Instance=this;
        DontDestroyOnLoad(this.gameObject);
        Object = new ArrayList();
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
