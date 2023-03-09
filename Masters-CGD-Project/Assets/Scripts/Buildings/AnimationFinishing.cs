using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationFinishing : MonoBehaviour
{
    public BuildInteraction buildInteraction;

    private void AnimationEnd()
    {
        buildInteraction.AnimationEnd();
    }
}
