using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelWall : MonoBehaviour
{

    public GameObject levelFX;
    [SerializeField] public GameObject mainUpgrade;
    [SerializeField] private int health;

    // Start is called before the first frame update
    void Start()
    {
        levelFX.SetActive(false);
        mainUpgrade.SetActive(false);
    }

}
