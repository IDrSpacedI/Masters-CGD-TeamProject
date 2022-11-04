using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelWall : MonoBehaviour
{

    public GameObject levelFX;
    //To play the animation;
    [SerializeField] public GameObject mainUpgrade;
    //TODO
    [SerializeField] private int health;

    // Start is called before the first frame update
    void Start()
    {
        //levelFX.SetActive(false);
        //mainUpgrade.SetActive(false);
    }

}
