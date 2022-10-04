using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class InteractionPromptUI : MonoBehaviour
{
    private Camera mainCamera;
    [SerializeField] private TextMeshProUGUI meshText;
    [SerializeField] private GameObject panel;
    public bool isDisplayed = false;



    private void Start()
    {
        mainCamera = Camera.main;
        panel.SetActive(false);

    }
    //TODO : text box always faces the camera 
    private void LateUpdate()
    {
        //var rotation = mainCamera.transform.rotation;
        //transform.LookAt(transform.position + rotation * Vector3.forward, rotation * Vector3.up);
    }

    //Show text with prompt
    public void startPrompt(string promptText)
    {
        meshText.text = promptText;
        panel.SetActive(true);
        isDisplayed = true;
    }

    //Text with prompt disappears
    public void closePrompt()
    {
        panel.SetActive(false);
        isDisplayed = false;


    }

}
