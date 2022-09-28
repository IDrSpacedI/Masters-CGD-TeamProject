using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{

    //allows other script to access and turn off player input (incase we need in future)
    public static bool disableMovement = false;

    //basic player movement variables and pariameter
    public float speed = 10f;
    public float gravity = -9.81f;
    public float jumpHeight = 2f;
    bool isGrounded;

    //define and set up ground check system for gravity
    public Transform groundCheck;
    public float groundDistance = 0.3f;
    public LayerMask groundMask;

    //player gravity velocity, increases the longer in air
    public Vector3 velocity;

    public Animator playerAnimtor;

    public bool playerIdle = true;

    [SerializeField]private Rigidbody playerRigBod;
	private float horizontalIn;
    private bool jumping = false;

	// Awake is called before start()
	private void Awake()
    {
        //just to make sure when the game starts the player is allowed to move (redundent, but just incase UwU)
        disableMovement = false;
        playerIdle = true;
    }

    // Start is called before the first frame update
    private void Start()
    {
        //playerAnimtor = GetComponentInChildren<Animator>();
    }

    // Update is called once per frame
    private void Update()
    {
        //allow player movement function to be stopped when needed
        if(!disableMovement)
        {
            PlayerJump();
            PlayerMove();
            //isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);
        }

        /**if (playerIdle)
        {
            playerAnimtor.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
        }**/
    }

    private void FixedUpdate()
    {
		if (jumping)
		{
            playerRigBod.AddForce(Vector3.up * jumpHeight, ForceMode.VelocityChange);
            jumping = false;
        }
        
        playerRigBod.velocity = new Vector3(0, playerRigBod.velocity.y, horizontalIn);
        Debug.Log(playerRigBod.velocity);
    }

    //function used to move the player
    public void PlayerMove()
    {
        //get player A&D input
        
        horizontalIn = Input.GetAxis("Horizontal") * speed;
        

        if (Input.GetKey(KeyCode.A))
        {
            playerIdle = false;
            playerAnimtor.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);

        }
        else if (Input.GetKey(KeyCode.D))
        {
            playerIdle = false;
            playerAnimtor.SetFloat("Speed", 0.5f, 0.1f, Time.deltaTime);
        }
        else
        {
            playerIdle = true;
            playerAnimtor.SetFloat("Speed", 0.25f, 0.1f, Time.deltaTime);
        }

    }

    //function used to allow the player to jump
    public void PlayerJump()
    {
        //add up velocity when the jump button is pressed
        //if (Input.GetButtonDown("Jump") && isGrounded)
        if (Input.GetButtonDown("Jump"))
        {
            //jump velocity calculation
            jumping = true;
        }
    }

    //function used to implenment artifical gravity
    public void PlayerGravity()
    {
        //get reference from ground check to see if player is on object that stops gravity
        isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);

        //adds slight down velocity to keep player on the ground
        if (isGrounded && velocity.y < 0)
        {
            velocity.y = -2f;
        }

        //moves player
        //velocity.y += gravity * Time.deltaTime;
        //controller.Move(velocity * Time.deltaTime);
    }

	
}
