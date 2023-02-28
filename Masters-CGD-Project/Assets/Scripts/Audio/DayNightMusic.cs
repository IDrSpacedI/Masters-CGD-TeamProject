using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DayNightMusic : MonoBehaviour
{
    private LightingManager lm;
    private SoundManager sm;
    [SerializeField]private string nowPlaying;
    private States state;
    private States temp;
    private string day;
    private string night;

    // Start is called before the first frame update
    void Start()
    {
        lm = FindObjectOfType<LightingManager>();
        sm = FindObjectOfType<SoundManager>();
        state = lm.state;
        temp = state;
        day = "MusicDay";
        night = "MusicNight";
        nowPlaying = day;
    }

    // Update is called once per frame
    void Update()
    {
        temp = lm.state;
        if (temp != state)
        {
            if(temp == States.night)
			{
                nowPlaying = night;
                sm.StopSound(day);
                sm.PlaySound(night);
			}
            if(temp == States.day)
			{
                nowPlaying = day;
                sm.StopSound(night);
                sm.PlaySound(day);
			}
        }
        state = lm.state;
    }
}
