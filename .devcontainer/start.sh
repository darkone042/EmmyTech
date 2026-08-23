#!/bin/bash
set -e

echo "========================================="
echo "  STARTING TECH AGENCY SERVICES"
echo "  OpenCode → Godmode → OmniRoute Chain"
echo "  FULL ACCESS MODE (E2EE Enabled)"
echo "========================================="

# Start phpMyAdmin
echo "📊 Starting phpMyAdmin on port 8081..."
php -S 0.0.0.0:8081 -t /var/www/html/phpmyadmin/ 2>&1 > /workspace/logs/phpmyadmin.log &

# Start CodeIgniter
echo "🌐 Starting CodeIgniter on port 8080..."
cd /workspaces/${localWorkspaceFolderBasename}
php spark serve --host 0.0.0.0 --port 8080 2>&1 > /workspace/logs/codeigniter.log &

# Start Godmode
echo "🧠 Starting Godmode API on port 7860..."
docker run -d -p 7860:7860 \
  -e OPENROUTER_API_KEY="$OPENROUTER_API_KEY" \
  -e OPENROUTER_API_BASE="http://172.17.0.1:20128/v1" \
  -e GODMODE_API_KEY="devsecretpass" \
  -e GODMODE_TIER="enterprise" \
  --name godmode-server \
  --restart unless-stopped \
  gm-api 2>&1 > /workspace/logs/godmode.log &

sleep 5

# Start OmniRoute
echo "🚀 Starting OmniRoute on port 20128..."
cd /home/omniroute-src && npm run start 2>&1 > /workspace/logs/omniroute.log &

sleep 5

# ======================================================================
# OPTION 1: Start OpenCode Web GUI (Cloudflare accessible)
# ======================================================================
echo "💻 Starting OpenCode Web GUI on port 4096..."
export OPENCODE_SERVER_PASSWORD="yoursecuredevpassword"
opencode web --hostname 0.0.0.0 --port 4096 2>&1 > /workspace/logs/opencode-web.log &

sleep 3

# ======================================================================
# OPTION 2: Start OpenCode E2EE Remote Control (Full Access)
# ======================================================================
echo "🔐 Starting OpenCode E2EE Remote Control on port 4097..."
export OPENCODE_REMOTE_SECRET="yourremotecontrolsecret"
opencode remote --hostname 0.0.0.0 --port 4097 --secret "$OPENCODE_REMOTE_SECRET" 2>&1 > /workspace/logs/opencode-remote.log &

sleep 10

# ======================================================================
# Generate Cloudflare Tunnels for ALL services
# ======================================================================
echo "🌩️ Generating Cloudflare Tunnel Links..."
echo "========================================="
echo "  PUBLIC LINKS (Cloudflare Tunnels)"
echo "========================================="

echo "--> CodeIgniter App (Port 8080):"
cloudflared tunnel --url http://localhost:8080 2>&1 | grep -E "https://.*\.trycloudflare\.com" || echo "  (Check terminal output for URL)"

echo "--> phpMyAdmin (Port 8081):"
cloudflared tunnel --url http://localhost:8081 2>&1 | grep -E "https://.*\.trycloudflare\.com" || echo "  (Check terminal output for URL)"

echo "--> OmniRoute Gateway (Port 20128):"
cloudflared tunnel --url http://localhost:20128 2>&1 | grep -E "https://.*\.trycloudflare\.com" || echo "  (Check terminal output for URL)"

echo "--> Godmode API (Port 7860):"
cloudflared tunnel --url http://localhost:7860 2>&1 | grep -E "https://.*\.trycloudflare\.com" || echo "  (Check terminal output for URL)"

echo "--> OpenCode Web GUI (Port 4096):"
cloudflared tunnel --url http://localhost:4096 2>&1 | grep -E "https://.*\.trycloudflare\.com" || echo "  (Check terminal output for URL)"

echo "--> OpenCode Remote Control E2EE (Port 4097):"
cloudflared tunnel --url http://localhost:4097 2>&1 | grep -E "https://.*\.trycloudflare\.com" || echo "  (Check terminal output for URL)"

echo "========================================="
echo "✅ All services started!"
echo ""
echo "📝 ACCESS YOUR SERVICES:"
echo "   - Web GUI: Open the OpenCode Web GUI link above"
echo "   - Full Terminal Access: Use the Remote Control link"
echo "   - Login: opencode / yoursecuredevpassword"
echo ""
echo "🔐 E2EE Remote Control:"
echo "   - Open the Remote Control link"
echo "   - Enter secret: yourremotecontrolsecret"
echo "   - You now have FULL terminal access!"
