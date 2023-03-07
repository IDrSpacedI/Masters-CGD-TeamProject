using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProccessing : MonoBehaviour
{
    [SerializeField] private PostProcessVolume _postprocessVolume;
    private Bloom _bloom;
    // Start is called before the first frame update
    void Start()
    {
        _postprocessVolume.profile.TryGetSettings(out _bloom);
    }

   
}
