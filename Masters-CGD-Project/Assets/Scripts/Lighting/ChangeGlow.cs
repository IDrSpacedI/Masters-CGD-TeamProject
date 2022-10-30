using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ChangeGlow : MonoBehaviour
{
    [SerializeField] float lerpDuration = 10;
    public float startValue = 0;
    public float endValue = 0f;
    public float timeElapsed = 0f;

    public float glow = 0;
    public bool transition = false;

    private Bloom bloom;
    [SerializeField] Volume globalVolume;
    [SerializeField] LightingManager lightningManager;


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
            Debug.Log("transition");
            glow = Mathf.Lerp(startValue, endValue, timeElapsed / lerpDuration);
            bloom.intensity.value = glow;
            timeElapsed += Time.deltaTime;
        }
        //Start Transition if it's sunrise
        else if (!transition && lightningManager.TimeOfDay >= 5f && lightningManager.TimeOfDay < 5.02f)
        {
            Debug.Log("sunrise");
            transition = true;
            startValue = 4f;
            endValue = 0f;
        }
        //Start Transition if it's sundown
        else if (!transition && lightningManager.TimeOfDay >= 18.5f && lightningManager.TimeOfDay < 18.52f)
        {
            Debug.Log("sundown");
            transition = true;
            startValue = 0f;
            endValue = 4f;
        }
        //Transition over
        if (lerpDuration <= timeElapsed)
        {
            Debug.Log("reset");
            transition = false;
            timeElapsed = 0f;
        }
    }
}