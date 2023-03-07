using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.Rendering.RendererUtils;


public class PostProccessing : MonoBehaviour
{
    [SerializeField] private PostProcessVolume _postprocessVolume;
    private Bloom _bloom;
    private DepthOfField _depthOfField;

    // Start is called before the first frame update
    void Start()
    {
        _postprocessVolume.profile.TryGetSettings(out _bloom);
        _postprocessVolume.profile.TryGetSettings(out _depthOfField);

    }

    public void AmbientOcclusionOff(bool value_B)
    {
        _bloom.active = value_B;              
    }

    public void DepthofFieldOff(bool value_d)
    {
        _depthOfField.active = value_d;
    }






}
