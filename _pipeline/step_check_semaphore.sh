#!/bin/bash
source "/opt/sb/sb-pipeline.sh"
set -e

# -----------------------------------------------------
# Settings
# -----------------------------------------------------
source "_pipeline/config.sh"

# Check the Semaphore build before we make any code live
check_semaphore_before_proceeding
