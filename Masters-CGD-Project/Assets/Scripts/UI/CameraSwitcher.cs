using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Cinemachine;

public static class CameraSwitcher
{
    static List<CinemachineVirtualCamera> cameras = new List<CinemachineVirtualCamera>();

    static CinemachineVirtualCamera Activecam = null;


    public static bool IsActiveCamera(CinemachineVirtualCamera camera)
    {
        return camera == Activecam;
    }

    public static void CameraPriority(CinemachineVirtualCamera camera)
    {
        camera.Priority = 10;
        Activecam = camera;

        foreach(CinemachineVirtualCamera c in cameras)
        {
            if(c != camera && camera.Priority !=0 )
            {
                c.Priority = 0;
            } 
        }
    }


    public static void Register(CinemachineVirtualCamera camera)
    {
        cameras.Add(camera);
        Debug.Log("camera registered:" + camera);
    }

    public static void unRegister(CinemachineVirtualCamera camera)
    {
        cameras.Remove(camera);
        Debug.Log("camera unregistered" + camera);
    }

}
