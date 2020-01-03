using UnityEngine;

public class BlurPostProcessing : MonoBehaviour
{
    [SerializeField]
    private Material _postProcessingMaterial = null;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture temporaryTexture = RenderTexture.GetTemporary(source.width, source.height);
        Graphics.Blit(source, temporaryTexture, _postProcessingMaterial, 0);
        Graphics.Blit(temporaryTexture, destination, _postProcessingMaterial, 1);
        RenderTexture.ReleaseTemporary(temporaryTexture);
    }
}
