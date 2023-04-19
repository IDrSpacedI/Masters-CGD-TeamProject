using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoinsAnimation : MonoBehaviour
{
    public Animator[] coin_animator;

    private void OnEnable()
    {
        for (int i = 0; i < coin_animator.Length; i++)
        {
            coin_animator[i].Play("coin1");
        }
    }
}
