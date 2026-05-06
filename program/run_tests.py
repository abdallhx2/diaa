"""
Edu Smart Assistant — Master Test Runner
==========================================
Runs all test systems in sequence:
  1. Start backend server
  2. Run backend API lifecycle tests (pytest)
  3. Run admin panel Playwright tests
  4. Print summary

Usage:
  python run_tests.py                    # Run all tests
  python run_tests.py --backend-only     # Backend API tests only
  python run_tests.py --admin-only       # Playwright admin tests only
  python run_tests.py --headed           # Playwright with visible browser
"""

import subprocess
import sys
import os
import time
import signal
import argparse

# Colors for terminal output
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
BOLD = "\033[1m"
RESET = "\033[0m"

ROOT = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.join(ROOT, "backend")
ADMIN_DIR = os.path.join(ROOT, "admin")


def banner(text):
    print(f"\n{CYAN}{BOLD}{'=' * 60}{RESET}")
    print(f"{CYAN}{BOLD}  {text}{RESET}")
    print(f"{CYAN}{BOLD}{'=' * 60}{RESET}\n")


def step(text):
    print(f"{YELLOW}>>> {text}{RESET}")


def success(text):
    print(f"{GREEN}  OK {text}{RESET}")


def fail(text):
    print(f"{RED}  FAIL {text}{RESET}")


def wait_for_backend(url="http://localhost:8000", timeout=30):
    """Wait for backend to be reachable."""
    import urllib.request
    import urllib.error

    step(f"Waiting for backend at {url}...")
    start = time.time()
    while time.time() - start < timeout:
        try:
            req = urllib.request.Request(url)
            urllib.request.urlopen(req, timeout=3)
            success("Backend is running")
            return True
        except (urllib.error.URLError, ConnectionError, OSError):
            time.sleep(1)
    fail(f"Backend not reachable after {timeout}s")
    return False


def start_backend():
    """Start the backend server in the background."""
    step("Starting backend server...")
    # Delete old SQLite DB for clean state
    db_path = os.path.join(BACKEND_DIR, "edu_smart.db")
    for suffix in ["", "-shm", "-wal"]:
        p = db_path + suffix
        if os.path.exists(p):
            os.remove(p)
            print(f"  Removed {os.path.basename(p)}")

    env = os.environ.copy()
    env["PYTHONPATH"] = BACKEND_DIR

    proc = subprocess.Popen(
        [sys.executable, "-m", "uvicorn", "app.main:app", "--port", "8000"],
        cwd=BACKEND_DIR,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        creationflags=subprocess.CREATE_NEW_PROCESS_GROUP if sys.platform == "win32" else 0,
    )

    if not wait_for_backend():
        proc.terminate()
        sys.exit(1)

    return proc


def run_backend_tests():
    """Run pytest lifecycle tests against running backend."""
    banner("PHASE 1: Backend API Lifecycle Tests")
    result = subprocess.run(
        [sys.executable, "-m", "pytest", "tests/test_lifecycle.py", "-v", "--tb=short", "-s"],
        cwd=BACKEND_DIR,
    )
    return result.returncode == 0


def run_admin_tests(headed=False):
    """Run Playwright tests for admin panel."""
    banner("PHASE 2: Admin Panel Playwright Tests")

    # Check if node_modules exists
    if not os.path.exists(os.path.join(ADMIN_DIR, "node_modules")):
        step("Installing admin dependencies...")
        subprocess.run(["npm", "install"], cwd=ADMIN_DIR, shell=True)

    # Install Playwright browsers if needed
    step("Ensuring Playwright browsers are installed...")
    subprocess.run(["npx", "playwright", "install", "chromium"], cwd=ADMIN_DIR, shell=True)

    args = ["npx", "playwright", "test", "tests/lifecycle.spec.ts"]
    if headed:
        args.append("--headed")

    result = subprocess.run(args, cwd=ADMIN_DIR, shell=True)
    return result.returncode == 0


def main():
    parser = argparse.ArgumentParser(description="Run Edu Smart Assistant tests")
    parser.add_argument("--backend-only", action="store_true", help="Run only backend tests")
    parser.add_argument("--admin-only", action="store_true", help="Run only admin Playwright tests")
    parser.add_argument("--headed", action="store_true", help="Run Playwright with visible browser")
    parser.add_argument("--no-start", action="store_true", help="Don't start backend (assume already running)")
    args = parser.parse_args()

    banner("Edu Smart Assistant — Test Suite")

    backend_proc = None
    results = {}

    try:
        # Start backend unless --no-start or only running admin with existing server
        if not args.no_start:
            backend_proc = start_backend()
        else:
            if not wait_for_backend():
                fail("Backend not running. Start it or remove --no-start flag.")
                sys.exit(1)

        # Run tests
        if not args.admin_only:
            results["Backend API"] = run_backend_tests()

        if not args.backend_only:
            results["Admin Playwright"] = run_admin_tests(headed=args.headed)

    finally:
        # Stop backend
        if backend_proc:
            step("Stopping backend server...")
            if sys.platform == "win32":
                backend_proc.terminate()
            else:
                os.kill(backend_proc.pid, signal.SIGTERM)
            backend_proc.wait(timeout=5)
            success("Backend stopped")

    # Print summary
    banner("TEST RESULTS SUMMARY")
    all_passed = True
    for name, passed in results.items():
        if passed:
            print(f"  {GREEN}{BOLD}PASS{RESET}  {name}")
        else:
            print(f"  {RED}{BOLD}FAIL{RESET}  {name}")
            all_passed = False

    print()
    if all_passed:
        print(f"  {GREEN}{BOLD}ALL TESTS PASSED{RESET}")
    else:
        print(f"  {RED}{BOLD}SOME TESTS FAILED{RESET}")
        sys.exit(1)


if __name__ == "__main__":
    main()
