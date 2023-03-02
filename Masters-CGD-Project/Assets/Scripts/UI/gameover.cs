using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class gameover : MonoBehaviour
{
    public GameObject moneyspend, npchired, soldires, builders, totalenemies, enemieskilled;
    

    private void OnEnable()
    {
        soldires.GetComponent< TextMeshProUGUI>().text +=  Gamemanager.Instance.totalsoldiers.ToString();
        moneyspend.GetComponent<TextMeshProUGUI>().text += Gamemanager.Instance.totalmoneyspend.ToString();
        npchired.GetComponent<TextMeshProUGUI>().text += Gamemanager.Instance.totalrecruits.ToString();
        builders.GetComponent<TextMeshProUGUI>().text += Gamemanager.Instance.totalbuilders.ToString();
        totalenemies.GetComponent<TextMeshProUGUI>().text += Gamemanager.Instance.totalenemies.ToString();
        enemieskilled.GetComponent<TextMeshProUGUI>().text += Gamemanager.Instance.enemieskilled.ToString();
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
