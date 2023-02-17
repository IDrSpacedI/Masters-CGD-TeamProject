Shader "Silvestris/See Through"
{
    Properties
    {
        _Size("Size", Float) = 1
        _PlayerPos("PlayerPos", Vector) = (0.5, 0.5, 0, 0)
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _Opacity("Opacity", Range(0, 1)) = 1
        [NoScaleOffset]_Main_Texture("Main Texture", 2D) = "white" {}
        _Tint("Tint", Color) = (0.5, 0.5, 0.5, 0)
        [NoScaleOffset]_Normal_Map("Normal Map", 2D) = "white" {}
        [NoScaleOffset]_Smoothness_Map("Smoothness Map", 2D) = "white" {}
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            UnityTexture2D _Property_4825cfecd38e41c98b69899717a8428c_Out_0 = UnityBuildTexture2DStructNoScale(_Normal_Map);
            float4 _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4825cfecd38e41c98b69899717a8428c_Out_0.tex, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.samplerstate, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_R_4 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.r;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_G_5 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.g;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_B_6 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.b;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_A_7 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.a;
            UnityTexture2D _Property_42af66d1b1d149bfadbede690d9ca385_Out_0 = UnityBuildTexture2DStructNoScale(_Smoothness_Map);
            float4 _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_42af66d1b1d149bfadbede690d9ca385_Out_0.tex, _Property_42af66d1b1d149bfadbede690d9ca385_Out_0.samplerstate, _Property_42af66d1b1d149bfadbede690d9ca385_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_544426d434a54528b6322887551940a9_R_4 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.r;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_G_5 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.g;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_B_6 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.b;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_A_7 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.a;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.NormalTS = (_SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = (_SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0).x;
            surface.Occlusion = 1;
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            UnityTexture2D _Property_4825cfecd38e41c98b69899717a8428c_Out_0 = UnityBuildTexture2DStructNoScale(_Normal_Map);
            float4 _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4825cfecd38e41c98b69899717a8428c_Out_0.tex, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.samplerstate, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_R_4 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.r;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_G_5 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.g;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_B_6 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.b;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_A_7 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.a;
            UnityTexture2D _Property_42af66d1b1d149bfadbede690d9ca385_Out_0 = UnityBuildTexture2DStructNoScale(_Smoothness_Map);
            float4 _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_42af66d1b1d149bfadbede690d9ca385_Out_0.tex, _Property_42af66d1b1d149bfadbede690d9ca385_Out_0.samplerstate, _Property_42af66d1b1d149bfadbede690d9ca385_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_544426d434a54528b6322887551940a9_R_4 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.r;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_G_5 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.g;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_B_6 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.b;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_A_7 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.a;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.NormalTS = (_SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = (_SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0).x;
            surface.Occlusion = 1;
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_4825cfecd38e41c98b69899717a8428c_Out_0 = UnityBuildTexture2DStructNoScale(_Normal_Map);
            float4 _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4825cfecd38e41c98b69899717a8428c_Out_0.tex, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.samplerstate, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_R_4 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.r;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_G_5 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.g;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_B_6 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.b;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_A_7 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.a;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.NormalTS = (_SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.xyz);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTERED_RENDERING
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
             float3 interp4 : INTERP4;
             float2 interp5 : INTERP5;
             float2 interp6 : INTERP6;
             float3 interp7 : INTERP7;
             float4 interp8 : INTERP8;
             float4 interp9 : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp5.xy =  input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.interp6.xy =  input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.interp9.xyzw =  input.shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.viewDirectionWS = input.interp4.xyz;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.interp5.xy;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.interp9.xyzw;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            UnityTexture2D _Property_4825cfecd38e41c98b69899717a8428c_Out_0 = UnityBuildTexture2DStructNoScale(_Normal_Map);
            float4 _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4825cfecd38e41c98b69899717a8428c_Out_0.tex, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.samplerstate, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_R_4 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.r;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_G_5 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.g;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_B_6 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.b;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_A_7 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.a;
            UnityTexture2D _Property_42af66d1b1d149bfadbede690d9ca385_Out_0 = UnityBuildTexture2DStructNoScale(_Smoothness_Map);
            float4 _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0 = SAMPLE_TEXTURE2D(_Property_42af66d1b1d149bfadbede690d9ca385_Out_0.tex, _Property_42af66d1b1d149bfadbede690d9ca385_Out_0.samplerstate, _Property_42af66d1b1d149bfadbede690d9ca385_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_544426d434a54528b6322887551940a9_R_4 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.r;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_G_5 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.g;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_B_6 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.b;
            float _SampleTexture2D_544426d434a54528b6322887551940a9_A_7 = _SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0.a;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.NormalTS = (_SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = 0;
            surface.Smoothness = (_SampleTexture2D_544426d434a54528b6322887551940a9_RGBA_0).x;
            surface.Occlusion = 1;
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float3 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_4825cfecd38e41c98b69899717a8428c_Out_0 = UnityBuildTexture2DStructNoScale(_Normal_Map);
            float4 _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0 = SAMPLE_TEXTURE2D(_Property_4825cfecd38e41c98b69899717a8428c_Out_0.tex, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.samplerstate, _Property_4825cfecd38e41c98b69899717a8428c_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_R_4 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.r;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_G_5 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.g;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_B_6 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.b;
            float _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_A_7 = _SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.a;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.NormalTS = (_SampleTexture2D_dd3eff281eaf48c4a07bac0a8bd8adb4_RGBA_0.xyz);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
             float4 interp2 : INTERP2;
             float4 interp3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            output.interp2.xyzw =  input.texCoord1;
            output.interp3.xyzw =  input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            output.texCoord1 = input.interp2.xyzw;
            output.texCoord2 = input.interp3.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma only_renderers gles gles3 glcore d3d11
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float4 uv0;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 interp0 : INTERP0;
             float4 interp1 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _Size;
        float2 _PlayerPos;
        float _Smoothness;
        float _Opacity;
        float4 _Main_Texture_TexelSize;
        float4 _Tint;
        float4 _Normal_Map_TexelSize;
        float4 _Smoothness_Map_TexelSize;
        CBUFFER_END
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_Main_Texture);
        SAMPLER(sampler_Main_Texture);
        TEXTURE2D(_Normal_Map);
        SAMPLER(sampler_Normal_Map);
        TEXTURE2D(_Smoothness_Map);
        SAMPLER(sampler_Smoothness_Map);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Length_float2(float2 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0 = UnityBuildTexture2DStructNoScale(_Main_Texture);
            float4 _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0 = SAMPLE_TEXTURE2D(_Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.tex, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.samplerstate, _Property_1d7e46c789b840eaa83c5be3fd6c591a_Out_0.GetTransformedUV(IN.uv0.xy));
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_R_4 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.r;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_G_5 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.g;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_B_6 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.b;
            float _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_A_7 = _SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0.a;
            float4 _Property_55c2fb17c5924180aab16892d9a13a95_Out_0 = _Tint;
            float4 _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2;
            Unity_Multiply_float4_float4(_SampleTexture2D_f31f5907e6a54bef98cc2a2b20dadb15_RGBA_0, _Property_55c2fb17c5924180aab16892d9a13a95_Out_0, _Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2);
            float _Property_76a09deb12524d6fb9292ca78f182cba_Out_0 = _Smoothness;
            float4 _ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
            float2 _Property_471f946ea7c54ed28b7426779f0e66b1_Out_0 = _PlayerPos;
            float2 _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3;
            Unity_Remap_float2(_Property_471f946ea7c54ed28b7426779f0e66b1_Out_0, float2 (0, 1), float2 (0.5, -1.5), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3);
            float2 _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2;
            Unity_Add_float2((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), _Remap_2910d3565d4f4ef699eacbfca0ad40b3_Out_3, _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2);
            float2 _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3;
            Unity_TilingAndOffset_float((_ScreenPosition_3960fe6c39654ecd8b0043bce4a1509d_Out_0.xy), float2 (1, 1), _Add_38a1b44f59af4da1a7513ec9c3f2db03_Out_2, _TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3);
            float2 _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2;
            Unity_Multiply_float2_float2(_TilingAndOffset_2cead0899f96441eb4fae45598b0f6f1_Out_3, float2(2, 2), _Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2);
            float2 _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2;
            Unity_Subtract_float2(_Multiply_5a442052ec624a65bdbddfb96050b2f4_Out_2, float2(1, 1), _Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2);
            float _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2;
            Unity_Divide_float(unity_OrthoParams.y, unity_OrthoParams.x, _Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2);
            float _Property_14e8bbe6c282454a800cab8090dc8057_Out_0 = _Size;
            float _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2;
            Unity_Multiply_float_float(_Divide_489f392fa70a4616af73c9cb09f9f9e8_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0, _Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2);
            float2 _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0 = float2(_Multiply_56592a2efdfe42089f44d16a36cafe73_Out_2, _Property_14e8bbe6c282454a800cab8090dc8057_Out_0);
            float2 _Divide_3549740240e94e72863548d9495c2083_Out_2;
            Unity_Divide_float2(_Subtract_08cb0ade47ab4aea946a60e7c7abf2d5_Out_2, _Vector2_26c16c90d4344c81b66ab42e53182413_Out_0, _Divide_3549740240e94e72863548d9495c2083_Out_2);
            float _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1;
            Unity_Length_float2(_Divide_3549740240e94e72863548d9495c2083_Out_2, _Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1);
            float _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1;
            Unity_OneMinus_float(_Length_83cb571bc7e9442f93f1ce708cbfdfba_Out_1, _OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1);
            float _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1;
            Unity_Saturate_float(_OneMinus_4bbb458bf3bc4a019b62041161b8b2ec_Out_1, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1);
            float _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3;
            Unity_Smoothstep_float(0, _Property_76a09deb12524d6fb9292ca78f182cba_Out_0, _Saturate_f4f86f98ecf340ddba3771e4c8ee02f9_Out_1, _Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3);
            float _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0 = _Opacity;
            float _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2;
            Unity_Multiply_float_float(_Smoothstep_7c2441ad4b5c4d9e877a56a258b84c3a_Out_3, _Property_a7a0c7c5bdd34cdebcceac4040e3b9f4_Out_0, _Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2);
            float _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            Unity_OneMinus_float(_Multiply_f3883a7bbe29435f9711b7d2635fefbe_Out_2, _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1);
            surface.BaseColor = (_Multiply_8278dbccebe1421ca3f901bbffe561a6_Out_2.xyz);
            surface.Alpha = _OneMinus_d291ae2c38b94ad6b1e612fccdbc81d3_Out_1;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
            // FragInputs from VFX come from two places: Interpolator or CBuffer.
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}