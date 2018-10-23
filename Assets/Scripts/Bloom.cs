using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Bloom : MonoBehaviour
{
    public Shader bloomShader;
    private Material bloomMaterial;

    // 高斯模糊迭代次数
    [Range(0, 5)]
    public int iterations = 5;

    // 模糊扩散
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;

    [Range(1, 8)]
    public int downSample = 2;

    [Range(0.0f, 4.0f)]
    public float luminanceThreshold = 4;

    private void Start()
    {
        bloomMaterial = new Material(bloomShader);
        bloomMaterial.hideFlags = HideFlags.DontSave;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (bloomMaterial != null)
        {
            bloomMaterial.SetFloat("_LuminanceThreshold", luminanceThreshold);

            int rtW = src.width / downSample;
            int rtH = src.height / downSample;

            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0, bloomMaterial, 0);

            for (int i = 0; i < iterations; i++)
            {
                bloomMaterial.SetFloat("_BlurSize", 1.0f + i * blurSpread);

                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                // 纵向卷积
                Graphics.Blit(buffer0, buffer1, bloomMaterial, 1);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                // 横向卷积
                Graphics.Blit(buffer0, buffer1, bloomMaterial, 2);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }

            bloomMaterial.SetTexture("_Bloom", buffer0);
            Graphics.Blit(src, dest, bloomMaterial, 3);

            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
