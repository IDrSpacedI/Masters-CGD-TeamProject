using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircleThrough : MonoBehaviour
{
    public static int posID = Shader.PropertyToID("_PlayerPos");
    public static int sizeID = Shader.PropertyToID("_Size");

    public Material mat;
    public Camera cam;
    public LayerMask mask;

    // Update is called once per frame
    void Update()
    {
  //      var dir = cam.transform.position - transform.position;
  //      var ray = new Ray(transform.position, dir);
  //      Debug.DrawRay(transform.position, dir, Color.green);

  //      if (Physics.Raycast(ray, 3000))
		//{
  //          //mat.SetFloat(sizeID, Mathf.SmoothStep(mat.GetFloat(sizeID), 1, 0.1f));
  //          mat.SetFloat(sizeID, 1);
  //          Debug.Log("yep");
  //      }
		//else
		//{
  //          //mat.SetFloat(sizeID, Mathf.SmoothStep(mat.GetFloat(sizeID), 0, 0.1f));
  //          mat.SetFloat(sizeID, 0);
  //      }

        var view = cam.WorldToViewportPoint(transform.position);
        mat.SetVector(posID, view);
    }
}
