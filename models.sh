#!/usr/bin/env bash
set -euo pipefail

echo "=== WAN 2.1 provisioning started $(date) ==="

# Пути в ai-dock/comfyui (стандарт /workspace/ComfyUI/models)
COMFY="/workspace/ComfyUI"

# Создаём нужные папки (ai-dock не всегда создаёт автоматически)
mkdir -p "${COMFY}/models/diffusion_models" \
         "${COMFY}/models/vae" \
         "${COMFY}/models/clip_vision" \
         "${COMFY}/models/text_encoders" \
         "${COMFY}/models/loras"

# Скачиваем напрямую (с resume -c и --no-check-certificate на случай блокировок HF)
wget -c --no-check-certificate -P "${COMFY}/models/diffusion_models/" \
  "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json"

wget -c --no-check-certificate -P "${COMFY}/models/vae/" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors"

wget -c --no-check-certificate -P "${COMFY}/models/clip_vision/" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"

wget -c --no-check-certificate -P "${COMFY}/models/text_encoders/" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"

wget -c --no-check-certificate -P "${COMFY}/models/loras/" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"

echo "=== Finished $(date) ==="
ls -lh "${COMFY}/models/"*/* 2>/dev/null | grep -iE 'wan|steady|vae|clip_vision|umt5|lightx2v' || echo "Files not found — check wget output in logs!"
