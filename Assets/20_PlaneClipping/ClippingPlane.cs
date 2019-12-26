using UnityEngine;

public class ClippingPlane : MonoBehaviour
{
    [SerializeField]
    private Material _material = null;

    private void Update()
    {
        /// Create a plane.
        Plane plane = new Plane(transform.up, transform.position);

        /// Transfer values from plane to Vector4.
        Vector4 planeData = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);

        /// Pass vector to shader.
        _material.SetVector("_Plane", planeData);
    }
}
