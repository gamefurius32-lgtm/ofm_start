#!/usr/bin/env bash
set -euo pipefail

echo "=== Custom WAN 2.1 provisioning started $(date) ==="

# Пути в ai-dock/vast-ai comfy (обычно /workspace/ComfyUI)
COMFY_DIR="${WORKSPACE:-/workspace}/ComfyUI"

# Создаём папки вручную
mkdir -p "${COMFY_DIR}/models/diffusion_models" \
         "${COMFY_DIR}/models/vae" \
         "${COMFY_DIR}/models/clip_vision" \
         "${COMFY_DIR}/models/text_encoders" \
         "${COMFY_DIR}/models/loras"

# Прямые wget (с -c для resume + --no-check-certificate если HF блочит)
wget -c --no-check-certificate -P "${COMFY_DIR}/models/diffusion_models/" \
  "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json"

wget -c --no-check-certificate -P "${COMFY_DIR}/models/vae/" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors"

wget -c --no-check-certificate -P "${COMFY_DIR}/models/clip_vision/" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"

wget -c --no-check-certificate -P "${COMFY_DIR}/models/text_encoders/" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"

wget -c --no-check-certificate -P "${COMFY_DIR}/models/loras/" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"

echo "=== Provisioning finished $(date) ==="
ls -lh "${COMFY_DIR}/models/"*/* 2>/dev/null | grep -iE 'wan|steady|vae|clip_vision|umt5|lightx2v' || echo "No files — check wget output above"
