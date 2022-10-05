using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public static class CamerSwticher
{
    static List<CinemachineVirtualCamera> cameras = new List<CinemachineVirtualCamera>();
    public static CinemachineVirtualCamera activeCamera = null;


    public static bool IsActiveCamera(CinemachineVirtualCamera camera)
    {
        return camera = activeCamera;
    }


    public static void CamPriority(CinemachineVirtualCamera camera)
    {
        camera.Priority = 10;
        activeCamera = camera;

        foreach(CinemachineVirtualCamera c in cameras)
        {
            if(c!= camera && c.Priority != 0)
            {
                c.Priority = 0;
            }
        }
    }


    public static void Register(CinemachineVirtualCamera camera)
    {
        cameras.Add(camera);
        Debug.Log("Camera Registered:" + camera);
    }
    public static void UnRegister(CinemachineVirtualCamera camera)
    {
        cameras.Remove(camera);
        Debug.Log("Camera Registered:" + camera);
    }
}
