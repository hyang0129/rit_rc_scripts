#!/bin/bash
# Transfer HalluLens data from RIT to Empire AI
# Run this script on RIT HPC inside a screen or tmux session

SOURCE="/shared/rc/llm-hd/HalluLens/"
DEST="hyang1@alpha1.empire-ai.org:LLM\ research/shared/"
KEY="$HOME/.ssh/empire_key"

echo "Starting HalluLens transfer..."
echo "Source: $SOURCE"
echo "Destination: $DEST"
echo ""

rsync -aH --info=progress2 --partial \
  -e "ssh -i $KEY -o StrictHostKeyChecking=accept-new" \
  "$SOURCE" "$DEST"

echo ""
echo "Transfer complete!"
