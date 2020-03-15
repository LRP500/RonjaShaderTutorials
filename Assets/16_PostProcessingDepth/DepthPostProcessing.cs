using UnityEngine;

public class DepthPostProcessing : MonoBehaviour
{
    [SerializeField]
    private Material _postProcessMaterial = null;

    [SerializeField]
    private float _waveSpeed = 1;

    [SerializeField]
    private bool _waveActive = false;

    private float _waveDistance = 0;

    private void Start()
    {
        Camera cam = GetComponent<Camera>();

        /// Generates a depth buffer for us to use
        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.Depth;
    }

    private void Update()
    {
        _waveDistance = _waveActive ? _waveDistance + (_waveSpeed * Time.deltaTime) : 0;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        _postProcessMaterial.SetFloat("_WaveDistance", _waveDistance);
        Graphics.Blit(source, destination, _postProcessMaterial);
    }
}

