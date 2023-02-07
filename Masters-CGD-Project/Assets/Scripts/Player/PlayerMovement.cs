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

    public float turnSmoothTime = 0.1f;
    float turnSmoothVelocity;

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
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;
    }

    // Update is called once per frame
    void Update()
    {
        //allow player movement function to be stopped when needed
        if (disableMovement == false)
        {
            PlayerMove();
            //PlayerJump();
            PlayerGravity();
        }

        if (isGrounded == false)
        {
            playerAnimtor.SetBool("Jump", false);
            //movementAnim.SetBool("Fall", true);
        }
        else
        {
            //movementAnim.SetBool("Fall", false);
        }

        /*if (Input.GetKey(KeyCode.T))
        {
            playerAnimtor.SetBool("Torch", true);
            playerAnimtor.SetTrigger("Torch Trigger");
        }*/

        if (Input.GetKey(KeyCode.Y))
        {
            playerAnimtor.SetBool("Torch", false);
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
        float horizontal = Input.GetAxisRaw("Horizontal");
        //float y = Input.GetAxis("Vertical");

        Vector3 direction = new Vector3(horizontal, 0f, 0).normalized;

        if (direction.magnitude >= 0.1f)
        {
            //Calculation for turning /direction angles
            float targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
            //smoothing turn rotation
            float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);
            //apply rotation
            transform.rotation = Quaternion.Euler(0f, angle, 0f);
            //gives the right direction to move with the camera's calculation
            Vector3 moveDir = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;
            //apply move
            controller.Move(moveDir.normalized * speed * Time.deltaTime);
        }

        /**
        //Calculation for turning /direction angles
        float targetAngle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg;
        //smoothing turn rotation
        float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);
        //apply rotation
        transform.rotation = Quaternion.Euler(0f, angle, 0f);

        Vector3 moveDir = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;
        //apply move
        controller.Move(direction.normalized * speed * Time.deltaTime);
        **/




        //move the player on the button press
        //Vector3 move = transform.forward * x;
        //controller.Move(move * speed * Time.deltaTime);


        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.D))
        {
            playerIdle = false;
            playerAnimtor.SetFloat("Speed", 0.25f, 0.1f, Time.deltaTime);

        }
        else
        {
            playerIdle = true;
            playerAnimtor.SetFloat("Speed", 0f, 0.1f, Time.deltaTime);
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

            playerAnimtor.SetBool("Jump", true);
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

        if (velocity.y < -4.5f)
        {
            playerAnimtor.SetBool("Fall", true);
        }
        else
        {
            playerAnimtor.SetBool("Fall", false);
        }

        //moves player
        velocity.y += gravity * Time.deltaTime;
        controller.Move(velocity * Time.deltaTime);
    }

    private void OnTriggerStay(Collider other)
    {
        //only work if the object trigger has the "Player" tag
        if (other.tag == "Build")
        {
            //Debug.Log("Touching Build");

        }
    }
}
