using System.Collections;
using System.Collections.Generic;

using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class PostProccessing : MonoBehaviour
{
    [SerializeField]
    Volume m_globalVol;
    [SerializeField]
    bool m_bloomOff = false;
    [SerializeField]
    bool m_dofOff = false;


    [ContextMenu("Set 0 bloom")]
    public void ExampleSettingsCode()
    {
        PlayerPrefs.SetInt("BloomOff", 0);
        SetBloom();
    }

    [ContextMenu("Set 1 bloom")]
    public void ExampleSettingsCode2()
    {
        PlayerPrefs.SetInt("BloomOff", 1);
        SetBloom();
    }

    [ContextMenu("Set 0 dof")]
    public void ExampleSettingsCodedof()
    {
        PlayerPrefs.SetInt("DofOff", 0);
        SetDoF();
    }

    [ContextMenu("Set 1 dof")]
    public void ExampleSettingsCode2dof()
    {
        PlayerPrefs.SetInt("DofOff", 1);
        SetDoF();
    }

    public void Awake()
    {
       

        SetBloom();
        SetDoF();
        
    }

    public void SetBloom()
    {
        m_bloomOff = !m_bloomOff;
        m_bloomOff = PlayerPrefs.GetInt("BloomOff", 1) >= 1;
        VolumeProfile profile = m_globalVol.profile;
        Bloom b = null;

        for (int i = 0; i < profile.components.Count; i++)
        {
            if (profile.components[i] is Bloom)
                b = profile.components[i] as Bloom;
        }
        if (b != null)
        {
            b.active = !m_bloomOff;
        }
    }

    public void SetDoF()
    {
        m_dofOff = !m_dofOff;
        m_bloomOff = PlayerPrefs.GetInt("DofOff", 1) >= 1;
        VolumeProfile profile = m_globalVol.profile;
        DepthOfField dof = null;


        for (int i = 0; i < profile.components.Count; i++)
        {
            if (profile.components[i] is DepthOfField)
                dof = profile.components[i] as DepthOfField;
        }
        if (dof != null)
        {
            dof.active = !m_bloomOff;
        }
    }
}





