compress_video() {
  ffmpeg -i "$1" -vcodec libx264 -crf 23 -preset medium -acodec aac -b:a 128k "${1}_compressed.mp4"
  open "$(dirname "$1")"
}
