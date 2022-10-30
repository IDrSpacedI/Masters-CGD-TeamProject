using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class LightingManager : MonoBehaviour
{
    [SerializeField] private Light DirectionslLight;
    [SerializeField] private DayNightCycle present;
    [SerializeField,Range(0,24)] public float TimeOfDay;

    private void Update()
    {
        if (present == null)
            return;
        if (Application.isPlaying)
        {
            TimeOfDay += Time.deltaTime / 80;
            TimeOfDay %= 24;
            if (TimeOfDay > 20)
                Gamemanager.Instance.Time_to_attac = true;
            else if(TimeOfDay>5)
                Gamemanager.Instance.Time_to_attac = false;
            UpdateLighting(TimeOfDay/24f);
        }
        else
        {
            UpdateLighting(TimeOfDay / 24);
        }
    }

    private void UpdateLighting(float timePercent)
    {
        RenderSettings.ambientLight = present.AmbientColor.Evaluate(timePercent);
        RenderSettings.fogColor = present.FogColor.Evaluate(timePercent);
        if(DirectionslLight != null)
        {
            DirectionslLight.color = present.DirectionalColor.Evaluate(timePercent);
            DirectionslLight.transform.localRotation = Quaternion.Euler(new Vector3((timePercent * 360f)-90,170f,0));
        }
    }

    private void OnValidate()
    {
        if (DirectionslLight != null)
            return;

        if(RenderSettings.sun != null)
        {
            DirectionslLight = RenderSettings.sun;
        }
        else
        {
            Light[] lights = GameObject.FindObjectsOfType<Light>();
            foreach(Light light in lights)
            {
                if(light.type == LightType.Directional)
                {
                    DirectionslLight = light;
                }
            }
        }

    }

}
