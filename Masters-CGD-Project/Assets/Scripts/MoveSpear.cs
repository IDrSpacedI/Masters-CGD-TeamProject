using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveSpear : MonoBehaviour
{
    public FighterAiArraySystem fighterAiArraySystem;
    public float speed = 1f;
    

    // Start is called before the first frame update
    void Start()
    {
        fighterAiArraySystem= GetComponent<FighterAiArraySystem>();
    }

    // Update is called once per frame
    void Update()
    {
        float step = speed * Time.deltaTime;
        transform.position = Vector3.MoveTowards(transform.position, fighterAiArraySystem.enemy[0].transform.position, step);
    }
}
