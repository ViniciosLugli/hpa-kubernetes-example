#!/bin/bash
set -e

RESULTS_DIR="results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$RESULTS_DIR"

echo "Starting load test..."
echo "Monitoring will run for 2 minutes"
echo ""

echo "Capturing baseline metrics..."
kubectl get hpa > "$RESULTS_DIR/baseline-hpa.txt"
kubectl top pods --no-headers > "$RESULTS_DIR/baseline-pods.txt"
kubectl top nodes > "$RESULTS_DIR/baseline-nodes.txt"

echo ""
echo "Launching load test..."
echo "URL: http://localhost:8080"
echo "Requests: 50000 | Concurrency: 30"
echo ""

ab -n 50000 -c 30 http://localhost:8080/ > "$RESULTS_DIR/load-test-${TIMESTAMP}.txt" 2>&1 &
LOAD_PID=$!

echo "Monitoring HPA and pods for 2 minutes..."
END_TIME=$(($(date +%s) + 120))

while [ $(date +%s) -lt $END_TIME ]; do
    echo "" >> "$RESULTS_DIR/hpa-timeline.txt"
    echo "=== $(date +%H:%M:%S) ===" >> "$RESULTS_DIR/hpa-timeline.txt"
    kubectl get hpa --no-headers >> "$RESULTS_DIR/hpa-timeline.txt" 2>/dev/null || true

    echo "" >> "$RESULTS_DIR/pods-timeline.txt"
    echo "=== $(date +%H:%M:%S) ===" >> "$RESULTS_DIR/pods-timeline.txt"
    kubectl get pods --no-headers >> "$RESULTS_DIR/pods-timeline.txt" 2>/dev/null || true

    echo "" >> "$RESULTS_DIR/pods-cpu-timeline.txt"
    echo "=== $(date +%H:%M:%S) ===" >> "$RESULTS_DIR/pods-cpu-timeline.txt"
    kubectl top pods --no-headers >> "$RESULTS_DIR/pods-cpu-timeline.txt" 2>/dev/null || true

    sleep 10
done

wait $LOAD_PID 2>/dev/null || true

echo ""
echo "Capturing final state..."
kubectl get hpa > "$RESULTS_DIR/final-hpa.txt"
kubectl describe hpa php-apache-hpa > "$RESULTS_DIR/hpa-events.txt"
kubectl get events --sort-by='.lastTimestamp' > "$RESULTS_DIR/k8s-events.txt"

echo ""
echo "Load test complete!"
echo "Results saved to: $RESULTS_DIR/"
ls -lh "$RESULTS_DIR/"