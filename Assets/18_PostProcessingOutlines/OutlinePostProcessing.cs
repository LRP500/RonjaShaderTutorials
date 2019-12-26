using UnityEngine;

public class OutlinePostProcessing : MonoBehaviour
{
    [SerializeField]
    private Material _postProcessMaterial = null;

    private Camera _camera = null;

    private void Start()
    {
        _camera = GetComponent<Camera>();

        /// Generates a depth and normal buffer for us to use.
        _camera.depthTextureMode = _camera.depthTextureMode | DepthTextureMode.DepthNormals;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        /// Get viewspace to worldspace matrix and pass it to shader.
        Matrix4x4 viewToWorld = _camera.cameraToWorldMatrix;
        _postProcessMaterial.SetMatrix("_viewToWorld", viewToWorld);

        Graphics.Blit(source, destination, _postProcessMaterial);
    }
}

