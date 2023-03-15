using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class EndGameHuD : MonoBehaviour
{
    public TextMeshProUGUI moneySpent;
    public TextMeshProUGUI NpcHired;
    public TextMeshProUGUI Builders;
    public TextMeshProUGUI soldiers;
    public TextMeshProUGUI enemiesKilled;
    public TextMeshProUGUI enemiesGenerated;


    private void Start()
    {
        Cursor.visible = true;
    }
    void Update()
    {
        moneySpent.text = Gamemanager.Instance.totalmoneyspend.ToString();
        NpcHired.text = Gamemanager.Instance.totalrecruits.ToString();
        Builders.text = Gamemanager.Instance.totalbuilders.ToString();
        soldiers.text = Gamemanager.Instance.totalsoldires.ToString();
        enemiesKilled.text = Gamemanager.Instance.enemieskilled.ToString();
        enemiesGenerated.text = Gamemanager.Instance.totalenemies.ToString();
    }
}
