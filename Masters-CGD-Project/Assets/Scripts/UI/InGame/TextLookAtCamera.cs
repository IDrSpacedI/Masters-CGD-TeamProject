using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextLookAtCamera : MonoBehaviour
{

    [SerializeField] public Transform lookAt;
    [SerializeField] public Vector3 offset;

    public Camera playerCamera;

    // Start is called before the first frame update
    void Start()
    {
        playerCamera = Camera.current;
    }

    // Update is called once per frame
    void Update()
    {
        //transform.LookAt(playerCamera.transform);

        Vector3 pos = playerCamera.WorldToScreenPoint(lookAt.position + offset);

        if (transform.position != pos)
             transform.position = pos;
    }
}
