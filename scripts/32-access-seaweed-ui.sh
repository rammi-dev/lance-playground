#!/bin/bash

echo "🌐 Setting up port-forwards for SeaweedFS Web UIs..."
echo ""
echo "This will forward:"
echo "  - Filer UI (File Browser):    http://localhost:8888"
echo "  - Admin UI (Cluster Mgmt):    http://localhost:23646"
echo "  - S3 API:                     http://localhost:8333"
echo ""
echo "Press Ctrl+C to stop all port-forwards"
echo ""

# Kill any existing port-forwards on these ports
pkill -f "port-forward.*seaweed" 2>/dev/null || true
sleep 1

# Start port-forwards in background
echo "Starting port-forwards..."

kubectl port-forward -n seaweed svc/seaweed-filer 8888:8888 &
PID_FILER=$!

kubectl port-forward -n seaweed svc/seaweed-admin 23646:23646 &
PID_ADMIN=$!

kubectl port-forward -n seaweed svc/seaweed-filer-s3 8333:8333 &
PID_S3=$!

# Wait a moment for port-forwards to establish
sleep 2

echo ""
echo "✅ Port-forwards active!"
echo ""
echo "📂 Filer UI (File Browser):     http://localhost:8888"
echo "⚙️  Admin UI (Cluster Mgmt):     http://localhost:23646"
echo "🪣 S3 API:                       http://localhost:8333"
echo ""
echo "Press Ctrl+C to stop"
echo ""

# Wait for Ctrl+C
trap "echo ''; echo 'Stopping port-forwards...'; kill $PID_FILER $PID_ADMIN $PID_S3 2>/dev/null; exit 0" INT TERM

# Keep script running
wait
