using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomisePlayerAppearance : MonoBehaviour
{
    [SerializeField] Material hair;
    [SerializeField] Material cloth;

    void Start()
    {
        hair.color = Random.ColorHSV(0f, 1f, 0f, 1f, 0.6f, 1f);
        cloth.SetColor("_Tint", Random.ColorHSV(0f, 100f, 0f, 1f, 0f, 1f));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
