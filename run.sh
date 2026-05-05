#!/usr/bin/env bash
# Thay thế Makefile — chạy: bash run.sh <target>
# Ví dụ: bash run.sh setup | api | lab | benchmark | seed | test | clean

set -euo pipefail

VENV=".venv"
if [ -d "$VENV/Scripts" ]; then
  BIN="$VENV/Scripts"
else
  BIN="$VENV/bin"
fi
PY="$BIN/python"
PIP="$BIN/pip"
JUPYTER="$BIN/jupyter"
JUPYTEXT="$BIN/jupytext"
UVICORN="$BIN/uvicorn"
PYTEST="$BIN/pytest"

case "${1:-help}" in

  setup)
    bash setup-lite.sh
    ;;

  verify)
    $PY scripts/verify_lite.py
    ;;

  seed)
    $PY scripts/seed_corpus.py
    ;;

  api)
    $UVICORN app.main:app --reload --port 8000
    ;;

  lab)
    $JUPYTEXT --to notebook --update notebooks/*.py 2>/dev/null || true
    $JUPYTER lab --notebook-dir=notebooks --ServerApp.token='' --no-browser
    ;;

  benchmark)
    $PY scripts/benchmark.py
    ;;

  test)
    $PYTEST -q
    ;;

  clean)
    rm -rf "$VENV" data/corpus_vn.jsonl data/golden_set.jsonl data/qdrant_storage \
           app/feast_repo/data app/feast_repo/registry.db app/feast_repo/online_store.db \
           notebooks/*.ipynb notebooks/.ipynb_checkpoints
    echo "Cleaned."
    ;;

  help|*)
    echo ""
    echo "Usage: bash run.sh <target>"
    echo ""
    echo "  setup      Setup venv + install deps + seed data + smoke test"
    echo "  verify     Smoke test (Qdrant + BM25 + Feast)"
    echo "  seed       (Re)generate corpus + golden set"
    echo "  api        Start FastAPI on http://localhost:8000"
    echo "  lab        Open Jupyter Lab on http://localhost:8888"
    echo "  benchmark  Precision@10 + P99 latency table"
    echo "  test       Run pytest"
    echo "  clean      Wipe venv + data + Feast artifacts"
    echo ""
    ;;

esac
