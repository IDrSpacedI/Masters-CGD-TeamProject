using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ChangeGlow : MonoBehaviour
{
    [SerializeField] float lerpDuration;
    private float startValue = 0f;
    private float endValue = 0f;
    public float timeElapsed = 0f;

    [SerializeField] float maxValueGlow;
    [SerializeField] float minValue;

    public float glow = 0;
    public bool transition = false;

    private Bloom bloom;
    [SerializeField] Volume globalVolume;
    [SerializeField] LightingManager lightningManager;


    [SerializeField] Light[] lightsTurnOff;
    [SerializeField] float maxValueLight;

    [SerializeField] GameObject fireflies;

    private void Start()
    {
        globalVolume.profile.TryGet(out bloom);
        glow = bloom.intensity.value;
    }
    // Update is called once per frame
    void Update()
    {
        //Continue Transition
        if (transition && lerpDuration >= timeElapsed)
        {
            //Debug.Log("transition");
            glow = Mathf.Lerp(startValue, endValue, timeElapsed / lerpDuration);
            bloom.intensity.value = glow;
            timeElapsed += Time.deltaTime;
        }
        //Start Transition if it's sunrise
        else if (!transition && lightningManager.TimeOfDay >= 5.5f && lightningManager.TimeOfDay < 5.52f)
        {
            //Debug.Log("sunrise");
            transition = true;
            startValue = maxValueGlow;
            endValue = minValue;

            //turn down the lanterns
            for (int i = 0; i < lightsTurnOff.Length; i++)
            {
                lightsTurnOff[i].intensity = 0.5f;
            }

            //Turn off fireflies
            fireflies.SetActive(false);
        }
        //Start Transition if it's sundown
        else if (!transition && lightningManager.TimeOfDay >= 18.5f && lightningManager.TimeOfDay < 18.52f)
        {
            //Debug.Log("sundown");
            transition = true;
            startValue = minValue;
            endValue = maxValueGlow;

            for (int i = 0; i < lightsTurnOff.Length; i++)
            {
                lightsTurnOff[i].intensity = maxValueLight;
            }
            fireflies.SetActive(true);
        }
        //Transition over
        if (lerpDuration <= timeElapsed)
        {
            //Debug.Log("reset");

            transition = false;
            timeElapsed = 0f;
        }
    }
}