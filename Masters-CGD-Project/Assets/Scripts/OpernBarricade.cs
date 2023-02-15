using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpernBarricade : MonoBehaviour
{
    [SerializeField] private GameObject barricadeDoor;
    private Animator anim;

	private void Awake()
	{
        anim = barricadeDoor.GetComponent<Animator>();
    }

	private void OnTriggerEnter(Collider collision)
    {
        if (collision.transform.tag == "Player" || collision.transform.tag == "FriendlyNPC")
        {
            anim.SetBool("Play", true);
        }
    }

    private void OnTriggerExit(Collider collision)
    {
        if (collision.transform.tag == "Player" || collision.transform.tag == "FriendlyNPC")
        {
            anim.SetBool("Play", false);
        }
    }
}
