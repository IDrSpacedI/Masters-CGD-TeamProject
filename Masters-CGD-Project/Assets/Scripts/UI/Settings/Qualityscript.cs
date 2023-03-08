using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.Rendering.Universal;

public class Qualityscript : MonoBehaviour
{
    [SerializeField] private TMP_Dropdown qualityDropdown;



    public void setQualityLevelDropdown(int index )
    {
        QualitySettings.SetQualityLevel(index, false);
    }

  
}
