using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    [Range(-0.5f, 0.5f)]
    [SerializeField]
    private float finalX = 0.4f;
    [Range(-0.5f, 0.5f)]
    [SerializeField]
    private float finalY = 0.4f;
    [Range(-1, 1)]
    [SerializeField]
    private float finalZ = 1;

    [Range(1, 5)]
    [SerializeField]
    private float cutSpeed = 1;

    private float maxX =float.NegativeInfinity;
    private float maxY = float.NegativeInfinity;
    private float maxZ = float.NegativeInfinity;

    private float x;
    private float y;
    private float z;

    private Material material;

    void Start()
    {
        material = GetComponent<MeshRenderer>().material;

        foreach (var vertex in GetComponent<MeshFilter>().mesh.vertices)
        {
            if (maxX< vertex.x)
            {
                maxX = vertex.x;
            }

            if (maxY < vertex.y)
            {
                maxY = vertex.y;
            }

            if (maxZ < vertex.z)
            {
                maxZ = vertex.z;
            }
        }

        StartCoroutine("CutX");
        StartCoroutine("CutY");
        StartCoroutine("CutZ");
    }

    private IEnumerator CutX()
    {
        x = maxX;
        while (x > finalX)
        {
            x -= (maxX - finalX) / 800 * cutSpeed;
            material.SetVector("_V", new Vector4(x, y, z, 0));
            yield return 0;
        }
        x = finalX;
    }

    private IEnumerator CutY()
    {
        y = maxY;
        while (y > finalY)
        {
            y -= (maxY - finalY) / 800 * cutSpeed;
            material.SetVector("_V", new Vector4(x, y, z, 0));
            yield return 0;
        }
        y = finalY;
    }

    private IEnumerator CutZ()
    {
        z = maxZ;
        while (z > finalZ)
        {
            y -= (maxZ - finalY) / 800 * cutSpeed;
            material.SetVector("_V", new Vector4(x, y, z, 0));
            yield return 0;
        }
        z = finalZ;
    }
}
