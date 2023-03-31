using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EntityManager : MonoBehaviour
{
    //Towers
    public List<GameObject> towerList;
    public List<GameObject> towerListLeft;
    public List<GameObject> towerListRight;
    public List<GameObject> SoldiersOnRight;
    public List<GameObject> SoldiersOnLeft;

    //Barricades
    public List<GameObject> barricadesLeft;
    public List<GameObject> barricadesRight;
    public List<GameObject> barricadeSoldiersOnRight;
    public List<GameObject> barricadeSoldiersOnLeft;
    public List<GameObject> barricadeList;

    public List<GameObject> enemyList;

}
