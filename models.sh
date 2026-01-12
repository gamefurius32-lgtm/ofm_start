#!/usr/bin/env bash
set -euo pipefail

echo "=== WAN 2.1 provisioning started $(date) ==="

# Путь в ai-dock/comfyui — стандарт /workspace/ComfyUI/models
COMFY="/workspace/ComfyUI"

# Создаём все нужные подпапки вручную (ai-dock не всегда делает это)
mkdir -p "${COMFY}/models/diffusion_models" \
         "${COMFY}/models/vae" \
         "${COMFY}/models/clip_vision" \
         "${COMFY}/models/text_encoders" \
         "${COMFY}/models/loras"

# Прямые wget — без функций, resume (-c) + обход сертификата (HF иногда блочит Vast IP)
wget -c --no-check-certificate -O "${COMFY}/models/diffusion_models/WAN2-1-SteadyDancer-FP8.json" \
  "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json"

wget -c --no-check-certificate -O "${COMFY}/models/vae/Wan2_1_VAE_bf16.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors"

wget -c --no-check-certificate -O "${COMFY}/models/clip_vision/clip_vision_h.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"

wget -c --no-check-certificate -O "${COMFY}/models/text_encoders/umt5_xxl_fp16.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"

wget -c --no-check-certificate -O "${COMFY}/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"

echo "=== Provisioning finished $(date) ==="
ls -lh "${COMFY}/models/"*/* 2>/dev/null | grep -iE 'wan|steady|vae|clip_vision|umt5|lightx2v' || echo "No files found — check if wget failed (look for errors above)"
