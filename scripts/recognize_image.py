#!/usr/bin/env python3
"""Image recognition via local Ollama Gemma 3 4B vision model."""
import argparse, base64, io, os, sys, json
from PIL import Image, ImageGrab
import requests

API_BASE = os.environ.get("IMAGE_API_BASE", "http://localhost:11434")
DEFAULT_MODEL = "gemma3:4b"
MAX_EDGE = 1280
DEFAULT_PROMPT = "识别图片里所有信息，使用 markdown 输出全部内容，并保持排版的一致"


def resize_image(path):
    img = Image.open(path).convert("RGB")
    w, h = img.size
    if max(w, h) <= MAX_EDGE:
        return img
    ratio = MAX_EDGE / max(w, h)
    new_size = (int(w * ratio), int(h * ratio))
    return img.resize(new_size, Image.LANCZOS)


def to_base64(img):
    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=85)
    return base64.b64encode(buf.getvalue()).decode()


def recognize(image_path, model=DEFAULT_MODEL, prompt=DEFAULT_PROMPT):
    img = resize_image(image_path)
    orig = Image.open(image_path).size
    print(f"[info] Original: {orig[0]}x{orig[1]}, Resized: {img.size[0]}x{img.size[1]}", file=sys.stderr)
    print(f"[info] Sending to {API_BASE}/v1/chat/completions (model={model})", file=sys.stderr)

    payload = {
        "model": model,
        "messages": [{
            "role": "user",
            "content": [
                {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{to_base64(img)}"}},
                {"type": "text", "text": prompt}
            ]
        }],
        "stream": False
    }

    url = f"{API_BASE}/v1/chat/completions"
    try:
        resp = requests.post(url, json=payload, timeout=600)
        resp.raise_for_status()
    except requests.exceptions.ConnectionError:
        print("[error] Cannot connect to Ollama. Run: ollama serve", file=sys.stderr)
        sys.exit(1)
    except requests.exceptions.Timeout:
        print("[error] Request timed out (>10min)", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"[error] API request failed: {e}", file=sys.stderr)
        sys.exit(1)

    data = resp.json()
    content = data["choices"][0]["message"]["content"]

    # Write to temp file for sandbox persistence
    out_path = os.path.join(os.environ.get("TEMP", "."), "rec_out.md")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(content)


def main():
    p = argparse.ArgumentParser(description="Image recognition via local Ollama vision model")
    p.add_argument("image", nargs="?", help="Path to image file")
    p.add_argument("--clipboard", action="store_true", help="Read image from clipboard")
    p.add_argument("--model", default=DEFAULT_MODEL, help=f"Ollama model name (default: {DEFAULT_MODEL})")
    p.add_argument("--prompt", default=DEFAULT_PROMPT, help="Custom recognition prompt")
    args = p.parse_args()

    if args.clipboard:
        img = ImageGrab.grabclipboard()
        if img is None:
            print("[error] No image in clipboard", file=sys.stderr)
            sys.exit(1)
        tmp = os.path.join(os.environ.get("TEMP", "."), "clipboard_img.png")
        img.convert("RGB").save(tmp)
        args.image = tmp

    if not args.image or not os.path.isfile(args.image):
        p.print_help()
        sys.exit(1)

    recognize(args.image, args.model, args.prompt)


if __name__ == "__main__":
    main()
