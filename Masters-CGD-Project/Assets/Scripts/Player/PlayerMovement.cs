using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    //get the character controller component
    public CharacterController controller;

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

    // Awake is called before start()
    private void Awake()
    {
        //just to make sure when the game starts the player is allowed to move (redundent, but just incase UwU)
        disableMovement = false;
        playerIdle = true;
    }

    // Start is called before the first frame update
    void Start()
    {
        //playerAnimtor = GetComponentInChildren<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        //allow player movement function to be stopped when needed
        if(disableMovement == false)
        {
            PlayerMove();
            PlayerJump();
            PlayerGravity();
        }

        /**if (playerIdle == true)
        {
            playerAnimtor.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
        }**/
    }

    //function used to move the player
    public void PlayerMove()
    {
        //get player A&D input
        float x = Input.GetAxis("Horizontal");

        //move the player on the button press
        Vector3 move = transform.forward * x;
        controller.Move(move * speed * Time.deltaTime);

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
        if (Input.GetButtonDown("Jump") && isGrounded)
        {
            //jump velocity calculation
            velocity.y = Mathf.Sqrt(jumpHeight * -2f * gravity);
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
        velocity.y += gravity * Time.deltaTime;
        controller.Move(velocity * Time.deltaTime);
    }
}
