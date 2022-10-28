using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootSteps : MonoBehaviour
{
    [SerializeField] private AudioClip[] stepsGrass;
    [SerializeField] private AudioClip[] stepsSoft;
    private bool moving = false;
    private Vector3 lastPos;
    private GameObject player;

	private void Awake()
	{
        player = GameObject.Find("---- Player ----");
    }

	private void Step()
    {
        if (moving)
        {
            AudioClip step1 = stepsSoft[Random.Range(0, stepsSoft.Length)];
            AudioSource.PlayClipAtPoint(step1, player.transform.position);
            AudioClip step2 = stepsGrass[Random.Range(0, stepsGrass.Length)];
            AudioSource.PlayClipAtPoint(step2, player.transform.position);
        }
    }

	private void Update()
	{
        lastPos = player.transform.position;
        if(lastPos != player.transform.position)
		{
            moving = true;
		}
		else
		{
            moving = false;
		}
	}
}
