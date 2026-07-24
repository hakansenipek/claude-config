#!/usr/bin/env bash
# Playwright ve Context7 MCP sunucularını --scope user ile idempotent kurar.
# Devcontainer post-create.sh'lardan çağrılmak üzere tasarlandı.
set -uo pipefail

echo "==> MCP sunucuları kontrol ediliyor (--scope user)"

claude mcp get playwright &>/dev/null \
  || claude mcp add playwright --scope user -- npx -y @playwright/mcp@latest \
  || echo "UYARI: playwright MCP eklenemedi, devam ediliyor"

claude mcp get context7 &>/dev/null \
  || claude mcp add context7 --scope user -- npx -y @upstash/context7-mcp@latest \
  || echo "UYARI: context7 MCP eklenemedi, devam ediliyor"

echo "==> MCP kurulumu tamamlandı"
