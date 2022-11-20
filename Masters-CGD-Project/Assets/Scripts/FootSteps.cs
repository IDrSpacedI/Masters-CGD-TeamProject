using UnityEngine;

public class FootSteps : MonoBehaviour
{
    private GameObject player;
    private PlayerMovement pMov;
    private bool moving;

	private void Awake()
	{
        player = GameObject.Find("---- Player ----");
        pMov = player.GetComponent<PlayerMovement>();
    }

	private void Step()
    {
        if (!pMov.playerIdle)
        {
            FindObjectOfType<SoundManager>().PlaySound("footStepsGrass");
            //FindObjectOfType<SoundManager>().PlaySound("footStepsSoft");
            //FindObjectOfType<SoundManager>().PlaySound("footStepsNew");
        }
    }
}
