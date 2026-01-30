#!/bin/bash
# Test connection from RIT to Empire

echo "Testing SSH connection to Empire AI..."
ssh -i ~/.ssh/empire_key -v hyang1@alpha1.empire-ai.org 'echo "Connection successful!"; hostname; pwd' 2>&1 | tail -30
