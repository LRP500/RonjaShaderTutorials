using UnityEngine;

public class Rotate : MonoBehaviour
{
    [SerializeField]
    private Vector3 _rotation = default;

    void Update()
    {
        RotateOverTime();
    }

    private void RotateOverTime()
    {
        transform.Rotate(_rotation * Time.deltaTime);
    }
}
