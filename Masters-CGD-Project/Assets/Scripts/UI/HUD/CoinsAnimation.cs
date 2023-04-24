using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoinsAnimation : MonoBehaviour
{
    [Header("aniamtion")]
    public Animator[] coin_animator;

    private void OnEnable()
    {
        /// play coin aniamtion
        for (int i = 0; i < coin_animator.Length; i++)
        {
            coin_animator[i].Play("coin1");
        }
    }
}
