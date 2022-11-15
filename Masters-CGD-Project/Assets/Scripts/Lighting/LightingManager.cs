using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public enum States
{
    none,
    day,
    night
}

[ExecuteInEditMode]
public class LightingManager : MonoBehaviour
{
    [SerializeField] private Light DirectionslLight;
    [SerializeField] private DayNightCycle present;
    [SerializeField,Range(0, 24)] public float TimeOfDay;
    public States state;
    public TextMeshProUGUI stateText;

    public void Start()
    {
        state = States.none;
    }

    private void Update()
    {
        if (present == null)
            return;
        if (Application.isPlaying)
        {
            TimeOfDay += Time.deltaTime;
            TimeOfDay %= 24;
            if (TimeOfDay > 20)
            {
                state = States.night;
                Gamemanager.Instance.Time_to_attac = true;
            }
            else if (TimeOfDay > 5)
            {
                state = States.day;
                Gamemanager.Instance.Time_to_attac = false;
            }

            UpdateLighting(TimeOfDay/24f);
        }
        else
        {
            UpdateLighting(TimeOfDay / 24);
        }

        stateText.text = "Sate" + ":" + state.ToString();
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
