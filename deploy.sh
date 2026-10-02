#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
REMOTE="${LIFE_REMOTE:-tpbili}"
REMOTE_ROOT="${LIFE_REMOTE_ROOT:-/var/www/life}"
PUBLIC_URL="${LIFE_PUBLIC_URL:-https://life.tpgofighting.top}"

cd "$PROJECT_DIR"

echo "==> 同步静态资源到远程服务器 $REMOTE:$REMOTE_ROOT..."
ssh -o BatchMode=yes "$REMOTE" "mkdir -p '$REMOTE_ROOT'"
rsync -avz --exclude '.git' --exclude '.DS_Store' "$PROJECT_DIR/" "$REMOTE:$REMOTE_ROOT/"

echo "==> 验证线上页面连通性..."
STATUS_CODE="$(curl -s -o /dev/null -w "%{http_code}" "$PUBLIC_URL" || true)"
echo "==> 部署完成！线上 HTTP 状态码: $STATUS_CODE"
echo "==> 访问地址: $PUBLIC_URL"
