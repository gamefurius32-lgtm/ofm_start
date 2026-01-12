#!/usr/bin/env bash
set -euo pipefail

echo "=== WAN 2.1 custom provisioning started ==="

# Если хочешь добавить свои custom nodes (опционально)
NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"   # если ещё не стоит
    # "https://github.com/Kijai/ComfyUI-WanVideo"   # если есть такой репозиторий
)

# Модели — добавляем в нужные массивы
# diffusion_models — для основных .json/.safetensors Wan моделей
DIFFUSION_MODELS=(
    "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json"
)

# VAE
VAE_MODELS=(
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors"
)

# CLIP Vision (очень важно — правильная папка clip_vision)
CLIP_MODELS=(   # В некоторых скриптах это clip, но для Wan — clip_vision
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"
)

# Text encoders
TEXT_ENCODER_MODELS=(
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"
)

# LoRAs
LORA_MODELS=(
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"
)

# --- Дальше ничего не меняй, если не уверен! ---
# (это вызовет стандартные функции из base provisioning)

# Установка nodes (если добавил выше)
if [[ ${#NODES[@]} -gt 0 ]]; then
    provisioning_get_nodes "${NODES[@]}"
fi

# Скачивание моделей в правильные папки
provisioning_get_files "${COMFYUI_DIR}/models/diffusion_models" "${DIFFUSION_MODELS[@]}"
provisioning_get_files "${COMFYUI_DIR}/models/vae" "${VAE_MODELS[@]}"
provisioning_get_files "${COMFYUI_DIR}/models/clip_vision" "${CLIP_MODELS[@]}"
provisioning_get_files "${COMFYUI_DIR}/models/text_encoders" "${TEXT_ENCODER_MODELS[@]}"
provisioning_get_files "${COMFYUI_DIR}/models/loras" "${LORA_MODELS[@]}"

echo "=== WAN 2.1 provisioning completed ==="
ls -lh "${COMFYUI_DIR}/models/"*/* | grep -iE 'wan|steady|vae|clip_vision|umt5|lightx2v' || echo "No files found? Check URLs!"
