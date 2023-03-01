using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextLookAtCamera : MonoBehaviour
{

    public GameObject player;
    private void LateUpdate()
    {
        transform.LookAt(transform.position + player.transform.rotation * Vector3.forward, player.transform.rotation * Vector3.up);
    }
}
