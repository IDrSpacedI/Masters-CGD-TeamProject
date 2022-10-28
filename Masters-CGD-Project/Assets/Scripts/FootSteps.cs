using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootSteps : MonoBehaviour
{
    [SerializeField] private AudioClip[] steps;
    private AudioSource source;


    void Awake()
    {
        source = GetComponent<AudioSource>();
    }

    private void Step()
    {
        AudioClip step = steps[Random.Range(0, steps.Length)];
        source.PlayOneShot(step);
    }
}
