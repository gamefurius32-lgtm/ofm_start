#!/bin/bash
set -e

source /venv/main/bin/activate

WORKSPACE=${WORKSPACE:-/workspace}
COMFYUI_DIR=${WORKSPACE}/ComfyUI

echo "=== Vast.ai ComfyUI provisioning ==="

# ─────────────────────────────────────────────
# 1. Clone ComfyUI if not exists
# ─────────────────────────────────────────────
if [[ ! -d "${COMFYUI_DIR}" ]]; then
    echo "=== Cloning ComfyUI ==="
    git clone https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_DIR}"
fi

cd "${COMFYUI_DIR}"

# ─────────────────────────────────────────────
# 2. Install ComfyUI base requirements
# ─────────────────────────────────────────────
if [[ -f "requirements.txt" ]]; then
    pip install --no-cache-dir -r requirements.txt
fi

# ─────────────────────────────────────────────
# 3. CONFIG
# ─────────────────────────────────────────────
APT_PACKAGES=()
PIP_PACKAGES=()

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    # "https://github.com/kijai/ComfyUI-WanVideoWrapper"
)

CHECKPOINT_MODELS=()
UNET_MODELS=()

LORA_MODELS=(
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"
)

VAE_MODELS=(
    "https://huggingface.co/Kijai/WanVideo_comfy/resolve/a328a632b80d44062fda7df9b6b1a7b2c3a5cf2c/Wan2_1_VAE_bf16.safetensors"
)

ESRGAN_MODELS=()
CONTROLNET_MODELS=()

WAN_JSON_MODELS=(
    "https://huggingface.co/diego97martinez/video_baile_stady_dancer/resolve/main/WAN2-1-SteadyDancer-FP8.json"
)

CLIP_VISION_MODELS=(
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"
)

TEXT_ENCODER_MODELS=(
    "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp16.safetensors"
)

# ─────────────────────────────────────────────
# 4. FUNCTIONS
# ─────────────────────────────────────────────
provisioning_get_files() {
    [[ -z $2 ]] && return
    local dir="$1"
    shift
    mkdir -p "$dir"

    for url in "$@"; do
        provisioning_download "$url" "$dir"
    done
}

provisioning_download() {
    local url="$1"
    local dir="$2"

    if [[ -n $HF_TOKEN && $url =~ huggingface.co ]]; then
        wget --header="Authorization: Bearer $HF_TOKEN" -qnc --content-disposition -P "$dir" "$url"
    elif [[ -n $CIVITAI_TOKEN && $url =~ civitai.com ]]; then
        wget --header="Authorization: Bearer $CIVITAI_TOKEN" -qnc --content-disposition -P "$dir" "$url"
    else
        wget -qnc --content-disposition -P "$dir" "$url"
    fi
}

# ─────────────────────────────────────────────
# 5. Install custom nodes
# ─────────────────────────────────────────────
mkdir -p custom_nodes

for repo in "${NODES[@]}"; do
    dir="${repo##*/}"
    path="custom_nodes/${dir}"
    requirements="${path}/requirements.txt"

    if [[ -d $path ]]; then
        echo "Updating node: ${dir}"
        cd "$path" && git pull
    else
        echo "Cloning node: ${dir}"
        git clone "$repo" "$path" --recursive
    fi

    [[ -f $requirements ]] && pip install --no-cache-dir -r "$requirements"
    cd "${COMFYUI_DIR}"
done

# ─────────────────────────────────────────────
# 6. Download models
# ─────────────────────────────────────────────
provisioning_get_files "models/checkpoints" "${CHECKPOINT_MODELS[@]}"
provisioning_get_files "models/unet" "${UNET_MODELS[@]}"
provisioning_get_files "models/lora" "${LORA_MODELS[@]}"
provisioning_get_files "models/controlnet" "${CONTROLNET_MODELS[@]}"
provisioning_get_files "models/vae" "${VAE_MODELS[@]}"
provisioning_get_files "models/esrgan" "${ESRGAN_MODELS[@]}"
provisioning_get_files "models/diffusion_models" "${WAN_JSON_MODELS[@]}"
provisioning_get_files "models/clip_vision" "${CLIP_VISION_MODELS[@]}"
provisioning_get_files "models/text_encoders" "${TEXT_ENCODER_MODELS[@]}"

# ─────────────────────────────────────────────
# 7. Launch ComfyUI
# ─────────────────────────────────────────────
echo "=== Starting ComfyUI ==="
python main.py --listen 0.0.0.0 --port 8188
