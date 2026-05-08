#!/bin/bash
# Save as: ~/verify-mcp.sh

echo "=== MCP SERVERS VALIDATION ==="
echo ""

# Check if Claude Code is installed
if ! command -v claude &>/dev/null; then
    echo "❌ Claude Code not installed"
    exit 1
fi

echo "✅ Claude Code installed: $(claude --version)"
echo ""

# Check ~/.claude.json exists and is valid JSON
if [ ! -f ~/.claude.json ]; then
    echo "❌ ~/.claude.json not found"
    exit 1
fi

if ! python3 -m json.tool ~/.claude.json >/dev/null 2>&1; then
    echo "❌ ~/.claude.json is not valid JSON"
    exit 1
fi

echo "✅ ~/.claude.json is valid"
echo ""

# Check each MCP server is configured
for server in terraform-mcp aws-core-mcp aws-pricing-mcp eks-mcp; do
    if grep -q "\"$server\"" ~/.claude.json; then
        echo "✅ $server configured"
    else
        echo "⚠️  $server NOT configured"
    fi
done

echo ""
echo "=== MCP SERVERS CONFIGURATION ==="
echo ""

# Show mcpServers section
python3 -m json.tool ~/.claude.json | grep -A 50 '"mcpServers"' | head -60

echo ""
echo "=== CREDENTIAL CHECKS ==="
echo ""

# Check AWS credentials
if aws sts get-caller-identity >/dev/null 2>&1; then
    ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    echo "✅ AWS credentials configured (Account: $ACCOUNT)"
else
    echo "⚠️  AWS credentials not working - some MCP servers will fail"
fi

# Check kubeconfig for EKS
if [ -f ~/.kube/config ]; then
    echo "✅ kubeconfig found"
else
    echo "⚠️  kubeconfig not found - EKS MCP will not work"
fi

echo ""
echo "=== END VALIDATION ==="