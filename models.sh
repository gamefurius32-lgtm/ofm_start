#!/usr/bin/env bash
set -euo pipefail

LOG="/tmp/wan_provision.log"
echo "Provisioning STARTED at $(date)" > $LOG

# Устанавливаем ComfyUI, если его нет (это главное!)
COMFY="/workspace/ComfyUI"
if [ ! -d "$COMFY" ]; then
  echo "Cloning ComfyUI..." | tee -a $LOG
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY" 2>&1 | tee -a $LOG
  cd "$COMFY"
  pip install -r requirements.txt 2>&1 | tee -a $LOG
  echo "ComfyUI installed" >> $LOG
else
  echo "ComfyUI already exists, updating..." | tee -a $LOG
  cd "$COMFY"
  git pull 2>&1 | tee -a $LOG
  pip install -r requirements.txt --upgrade 2>&1 | tee -a $LOG
fi

# Создаём кастомные папки
mkdir -p "${COMFY}/models/"{diffusion_models,vae,clip_vision,text_encoders,loras} 2>&1 | tee -a $LOG

# Скачиваем твои модели
echo "Downloading WAN models..." | tee -a $LOG

wget -c --no-check-certificate -O "${COMFY}/models/diffusion_models/WAN2-1-SteadyDancer-FP8.json" \
  "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json" 2>&1 | tee -a $LOG

wget -c --no-check-certificate -O "${COMFY}/models/vae/Wan2_1_VAE_bf16.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors" 2>&1 | tee -a $LOG

wget -c --no-check-certificate -O "${COMFY}/models/clip_vision/clip_vision_h.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors" 2>&1 | tee -a $LOG

wget -c --no-check-certificate -O "${COMFY}/models/text_encoders/umt5_xxl_fp16.safetensors" \
  "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors" 2>&1 | tee -a $LOG

wget -c --no-check-certificate -O "${COMFY}/models/loras/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" \
  "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors" 2>&1 | tee -a $LOG

echo "Provisioning FINISHED at $(date)" >> $LOG
ls -lh "${COMFY}/models/"*/* 2>&1 | grep -iE 'wan|steady|vae|clip_vision|umt5|lightx2v' >> $LOG || echo "No files — check wget errors in log" >> $LOG
