using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class bloodeffect : MonoBehaviour
{
    Color alpha;
    float tempvalue;
    // Start is called before the first frame update
    private void Awake()
    {
       
    }
    public void calleffect()
    {
       // Debug.Log("melvin awake is called");
        alpha = transform.GetChild(0).gameObject.GetComponent<Image>().color;
        alpha.a = 1;
        transform.GetChild(0).gameObject.GetComponent<Image>().color = alpha;
        tempvalue = 0;
        StartCoroutine(delay(.2f));
    }
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    IEnumerator delay(float i)
    {
        yield return new WaitForSeconds(i);
        //  damageui.GetComponent<RawImage>().enabled = false;
        tempvalue += .5f;
        alpha.a -= tempvalue;
        transform.GetChild(0).gameObject.GetComponent<Image>().color = alpha;

        if (alpha.a < .5f)
        {
            alpha.a = 0;
            transform.GetChild(0).gameObject.GetComponent<Image>().color = alpha;
            this.gameObject.SetActive(false);
            //StopAllCoroutines();
        }
        else
            StartCoroutine(delay(.2f));


    }
}
