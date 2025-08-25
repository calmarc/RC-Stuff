#!/bin/bash
# Eingabe- und Ausgabeordner
INPUT_DIR="./mp3"
OUTPUT_DIR="./wav"

mkdir -p "$OUTPUT_DIR"

for f in "$INPUT_DIR"/*.mp3; do
    base=$(basename "$f" .mp3)
    echo "Bearbeite: $base.mp3"

    # Schritt 1: Lautstärke anheben und nach WAV konvertieren
    ffmpeg -y -i "$f" -filter:a "volume=6dB" \
        -ar 16000 -ac 1 -acodec pcm_s16le \
        "$OUTPUT_DIR/${base}_temp.wav"

    # Schritt 2: Dynamisch normalisieren
    ffmpeg -y -i "$OUTPUT_DIR/${base}_temp.wav" \
        -filter:a "dynaudnorm=f=200:g=15" \
        "$OUTPUT_DIR/${base}.wav"

    rm "$OUTPUT_DIR/${base}_temp.wav"
done

echo "Fertig! Dateien liegen in $OUTPUT_DIR"
