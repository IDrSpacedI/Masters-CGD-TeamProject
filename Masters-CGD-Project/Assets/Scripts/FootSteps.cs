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
        FindObjectOfType<SoundManager>().Play("footStepsGrass");
        FindObjectOfType<SoundManager>().Play("footStepsSoft");
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
