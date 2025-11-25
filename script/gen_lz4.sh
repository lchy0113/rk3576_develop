mkdir -p ~/.local/bin

cat > ~/.local/bin/lz4 << 'EOF'
#!/usr/bin/env bash
# Wrapper for kernel build: drop unsupported options and call real /usr/bin/lz4

REAL_LZ4=/usr/bin/lz4

filtered=()
for a in "$@"; do
  case "$a" in
    --favor-decSpeed|-12)
    ;;
  *)
    filtered+=("$a")
    ;;
  esac
done

exec "$REAL_LZ4" "${filtered[@]}"
EOF

chmod +x ~/.local/bin/lz4
