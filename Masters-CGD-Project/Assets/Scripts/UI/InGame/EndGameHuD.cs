using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

// script by Oliver Lancashire
//sid 1901981
public class EndGameHuD : MonoBehaviour
{
    [Header("Text")]
    public TextMeshProUGUI moneySpent;
    public TextMeshProUGUI NpcHired;
    public TextMeshProUGUI Builders;
    public TextMeshProUGUI soldiers;
    public TextMeshProUGUI enemiesKilled;
    public TextMeshProUGUI enemiesGenerated;
    


    private void Start()
    {
        // set variables
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
        Time.timeScale = 1;
    }
    void Update()
    {
        // updates all text
        moneySpent.text = Gamemanager.Instance.totalmoneyspend.ToString();
        NpcHired.text = Gamemanager.Instance.totalrecruits.ToString();
        Builders.text = Gamemanager.Instance.totalbuilders.ToString();
        soldiers.text = Gamemanager.Instance.totalsoldires.ToString();
        enemiesKilled.text = Gamemanager.Instance.enemieskilled.ToString();
        enemiesGenerated.text = Gamemanager.Instance.totalenemies.ToString();
    }
    /// <summary>
    /// load scene
    /// </summary>
    /// <param name="index"></param>
    public void LoadScene(int index)
    {
        SceneManager.LoadScene(index);
    }

}
