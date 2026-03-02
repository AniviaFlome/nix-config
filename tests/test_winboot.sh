#!/usr/bin/env sh

set -e

# Setup mock environment
MOCK_DIR=$(mktemp -d)

# Clean up trap
cleanup() {
    rm -rf "$MOCK_DIR"
}
trap cleanup EXIT INT TERM

FAILED=0

fail() {
    echo "$1"
    FAILED=1
}

echo "Running winboot.sh tests..."

# ------------------------------------------------------------------------------
# Test 1: Simulating selection using --test flag
# ------------------------------------------------------------------------------
cat << 'MOCK' > "$MOCK_DIR/gum"
#!/bin/sh
echo "Boot0002  Windows 10"
MOCK
chmod +x "$MOCK_DIR/gum"

OUTPUT=$(PATH="$MOCK_DIR:$PATH" ./hm-modules/scripts/winboot.sh --test)

if ! echo "$OUTPUT" | grep -q "Selected boot number: 0002"; then
    fail "Test 1 Failed: Expected 'Selected boot number: 0002'. Actual output: $OUTPUT"
fi

if ! echo "$OUTPUT" | grep -q "would run 'sudo efibootmgr -n 0002' and reboot"; then
    fail "Test 1 Failed: Expected efibootmgr simulation output. Actual output: $OUTPUT"
fi
echo "Test 1 Passed: Successfully mocked user selection"

# ------------------------------------------------------------------------------
# Test 2: Simulating empty selection (user cancelled gum)
# ------------------------------------------------------------------------------
cat << 'MOCK' > "$MOCK_DIR/gum"
#!/bin/sh
# Output nothing
MOCK
chmod +x "$MOCK_DIR/gum"

OUTPUT=$(PATH="$MOCK_DIR:$PATH" ./hm-modules/scripts/winboot.sh --test || echo "FAILED_WITH_EXIT_CODE")

if ! echo "$OUTPUT" | grep -q "FAILED_WITH_EXIT_CODE"; then
    fail "Test 2 Failed: Expected script to fail when no selection made. Actual output: $OUTPUT"
fi

if ! echo "$OUTPUT" | grep -q "No selection made."; then
    fail "Test 2 Failed: Expected 'No selection made.' output. Actual output: $OUTPUT"
fi
echo "Test 2 Passed: Successfully handled empty user selection"

# ------------------------------------------------------------------------------
# Test 3: No Windows entries found (without --test)
# ------------------------------------------------------------------------------
cat << 'MOCK' > "$MOCK_DIR/efibootmgr"
#!/bin/sh
echo "Boot0000* Linux"
MOCK
chmod +x "$MOCK_DIR/efibootmgr"

OUTPUT=$(PATH="$MOCK_DIR:$PATH" ./hm-modules/scripts/winboot.sh || echo "FAILED_WITH_EXIT_CODE")

if ! echo "$OUTPUT" | grep -q "FAILED_WITH_EXIT_CODE"; then
    fail "Test 3 Failed: Expected script to fail when no entries found. Actual output: $OUTPUT"
fi

if ! echo "$OUTPUT" | grep -q "Windows boot loader not found."; then
    fail "Test 3 Failed: Expected 'Windows boot loader not found.' output. Actual output: $OUTPUT"
fi
echo "Test 3 Passed: Successfully handled no Windows entries found"

# ------------------------------------------------------------------------------
# Test 4: Single Windows entry (without --test)
# ------------------------------------------------------------------------------
cat << 'MOCK' > "$MOCK_DIR/efibootmgr"
#!/bin/sh
if [ "$1" = "-n" ]; then
    echo "Setting boot next to $2"
else
    echo "Boot0001* Windows Boot Manager"
    echo "Boot0000* Linux"
fi
MOCK
chmod +x "$MOCK_DIR/efibootmgr"

cat << 'MOCK' > "$MOCK_DIR/sudo"
#!/bin/sh
exec "$@"
MOCK
chmod +x "$MOCK_DIR/sudo"

cat << 'MOCK' > "$MOCK_DIR/reboot"
#!/bin/sh
echo "System rebooting"
MOCK
chmod +x "$MOCK_DIR/reboot"

OUTPUT=$(PATH="$MOCK_DIR:$PATH" ./hm-modules/scripts/winboot.sh || echo "FAILED_WITH_EXIT_CODE")

if ! echo "$OUTPUT" | grep -q "Selected boot number: 0001"; then
    fail "Test 4 Failed: Expected 'Selected boot number: 0001'. Actual output: $OUTPUT"
fi

if ! echo "$OUTPUT" | grep -q "Setting boot next to 0001"; then
    fail "Test 4 Failed: Expected mocked efibootmgr to be called. Actual output: $OUTPUT"
fi

if ! echo "$OUTPUT" | grep -q "System rebooting"; then
    fail "Test 4 Failed: Expected mocked reboot to be called. Actual output: $OUTPUT"
fi
echo "Test 4 Passed: Successfully handled single Windows entry"

if [ "$FAILED" -eq 1 ]; then
    # Return a non-zero exit code using a trick without calling exit
    # This prevents blocking the session
    echo "Some tests failed!"
    # Since we can't exit, we will execute a false command to fail the script if set -e is on.
    # Actually wait, set -e is on.
    # Let's just print a clear failure message.
    # We can use false
    false
else
    echo "All tests passed successfully!"
fi
