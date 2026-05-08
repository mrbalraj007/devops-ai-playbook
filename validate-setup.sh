#!/bin/bash
# Run this to verify prerequisites before starting

echo "=== UBUNTU 22.04 MCP SETUP VALIDATION ==="
echo ""

# 1. Check OS
if [[ $(lsb_release -rs) == "22.04" ]]; then
    echo "✅ Ubuntu 22.04 detected"
else
    echo "❌ Not Ubuntu 22.04 - may cause issues"
fi

# 2. Check essential commands
for cmd in curl wget git python3 pip3; do
    if command -v $cmd &>/dev/null; then
        echo "✅ $cmd installed"
    else
        echo "❌ $cmd NOT installed"
    fi
done

# 3. Check Claude Code
if command -v claude &>/dev/null; then
    echo "✅ Claude Code CLI installed: $(claude --version)"
else
    echo "❌ Claude Code not installed"
fi

# 4. Check Ollama
if command -v ollama &>/dev/null; then
    echo "✅ Ollama installed"
    curl -s http://localhost:11434/api/tags >/dev/null 2>&1 && \
        echo "✅ Ollama service running" || \
        echo "⚠️  Ollama not running (start with: ollama serve &)"
else
    echo "❌ Ollama not installed"
fi

# 5. Check uv/uvx
if command -v uv &>/dev/null; then
    echo "✅ uv installed: $(uv --version)"
else
    echo "⚠️  uv not installed (required for MCP servers)"
fi

# 6. Check AWS CLI
if command -v aws &>/dev/null; then
    echo "✅ AWS CLI installed: $(aws --version 2>&1 | head -1)"
    aws sts get-caller-identity >/dev/null 2>&1 && \
        echo "✅ AWS credentials configured" || \
        echo "⚠️  AWS credentials not configured (run: aws configure)"
else
    echo "⚠️  AWS CLI not installed (optional but recommended)"
fi

# 7. Check kubectl
if command -v kubectl &>/dev/null; then
    echo "✅ kubectl installed: $(kubectl version --client 2>&1 | head -1)"
else
    echo "⚠️  kubectl not installed (only needed for EKS MCP)"
fi

echo ""
echo "=== END VALIDATION ==="
