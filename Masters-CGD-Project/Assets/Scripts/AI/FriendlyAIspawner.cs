using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FriendlyAIspawner : MonoBehaviour
{
    public GameObject FriendlyAIprefab;
    public int tempday;

    private void Awake()
    {
        
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Gamemanager.Instance)
        if(tempday != FindObjectOfType<DaysCounter>().dayCount)
        {
            tempday = FindObjectOfType<DaysCounter>().dayCount;
            spawneNPC();
        }
    }
    void spawneNPC()
    {
        Instantiate(FriendlyAIprefab,transform.position,Quaternion.identity);
        Instantiate(FriendlyAIprefab,transform.position,Quaternion.identity);
    }
}
