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
    [SerializeField, Range(0, 24)] public float TimeOfDay;
    public States state;
    public TextMeshProUGUI stateText;
    public float speedFactor = 0.1f;
    public int dayCount;
    public TextMeshProUGUI dayTxt;
    private bool countCheck;
    private string temp = "day";

    [Header("Glow Change")]
    public List<Material> inUse;


    public void Start()
    {
        ResetIntensity();

		state = States.none;
        dayTxt.text = (dayCount + 1).ToString();
    }

    private void Update()
    {
        if (present == null)
            return;
        if (Application.isPlaying)
        {
            TimeOfDay += Time.deltaTime * speedFactor;
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
                countCheck = true;
            }
            ChangeGlow(state.ToString());

            UpdateLighting(TimeOfDay / 24f);
        }
        else
        {
            UpdateLighting(TimeOfDay / 24);
        }

        if (!(TimeOfDay < 23.9f && TimeOfDay > 0.1) && countCheck)
        {
            countCheck = false;
            dayCount++;
            dayTxt.text = (dayCount + 1).ToString();
        }

        stateText.text = "State" + ":" + state.ToString();
    }

    private void UpdateLighting(float timePercent)
    {
        RenderSettings.ambientLight = present.AmbientColor.Evaluate(timePercent);
        RenderSettings.fogColor = present.FogColor.Evaluate(timePercent);
        if (DirectionslLight != null)
        {
            DirectionslLight.color = present.DirectionalColor.Evaluate(timePercent);
            DirectionslLight.transform.localRotation = Quaternion.Euler(new Vector3((timePercent * 360f) - 90, 90, 0));
        }
    }

    private void OnValidate()
    {
        if (DirectionslLight != null)
            return;

        if (RenderSettings.sun != null)
        {
            DirectionslLight = RenderSettings.sun;
        }
        else
        {
            Light[] lights = GameObject.FindObjectsOfType<Light>();
            foreach (Light light in lights)
            {
                if (light.type == LightType.Directional)
                {
                    DirectionslLight = light;
                }
            }
        }

    }

    private void ChangeGlow(string state)
    {
        if (temp != state)
        {
            temp = state;
            for (int i = 0; i < inUse.Count; i++)
            {
                StartCoroutine(IntensityChange(state, inUse[i]));
            }
        }
    }

    private void ResetIntensity()
    {
		for (int i = 0; i < inUse.Count; i++)
		{
			inUse[i].SetColor("_EmissionColor", Color.white);
		}
	}

    IEnumerator IntensityChange(string state, Material mat)
    {
        for (float i = 0; i <= 4; i+=0.01f) { 
            if (state == "day")
            {
				mat.SetColor("_EmissionColor", mat.GetColor("_EmissionColor") / 1.01f);
			}
            else if (state == "night")
            {
				mat.SetColor("_EmissionColor", mat.GetColor("_EmissionColor") * 1.01f);
			}
			yield return new WaitForSeconds(0.01f);
		}
		
	}
    
}
