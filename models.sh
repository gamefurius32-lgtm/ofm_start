#!/usr/bin/env bash
set -euo pipefail

echo "WAN 2.1 provisioning STARTED at $(date)" > /tmp/wan_provision.log

COMFY="/workspace/ComfyUI"  # стандартный путь в ai-dock

mkdir -p "${COMFY}/models/"{diffusion_models,vae,clip_vision,text_encoders,loras} 2>&1 | tee -a /tmp/wan_provision.log

echo "Downloading WAN2-1-SteadyDancer-FP8.json" >> /tmp/wan_provision.log
wget -c -O "${COMFY}/models/diffusion_models/WAN2-1-SteadyDancer-FP8.json" \
  "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json" 2>&1 | tee -a /tmp/wan_provision.log

echo "Downloading Wan2_1_VAE_bf16.safetensors" >> /tmp/wan_provision.log
wget -c -O "${COMFY}/models/vae/Wan2_1_VAE_bf16.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors" 2>&1 | tee -a /tmp/wan_provision.log

echo "Downloading clip_vision_h.safetensors" >> /tmp/wan_provision.log
wget -c -O "${COMFY}/models/clip_vision/clip_vision_h.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors" 2>&1 | tee -a /tmp/wan_provision.log

echo "Downloading umt5_xxl_fp16.safetensors" >> /tmp/wan_provision.log
wget -c -O "${COMFY}/models/text_encoders/umt5_xxl_fp16.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors" 2>&1 | tee -a /tmp/wan_provision.log

echo "Downloading lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" >> /tmp/wan_provision.log
wget -c -O "${COMFY}/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" 2>&1 | tee -a /tmp/wan_provision.log

echo "Provisioning FINISHED at $(date)" >> /tmp/wan_provision.log
ls -lh "${COMFY}/models/"*/* 2>&1 | grep -iE 'wan|steady|vae|clip_vision|umt5|lightx2v' >> /tmp/wan_provision.log || echo "No WAN files found" >> /tmp/wan_provision.log
