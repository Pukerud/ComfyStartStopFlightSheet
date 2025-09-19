# Custom HiveOS Miner for ComfyUI

## Overview

This project provides a set of scripts to integrate a ComfyUI instance (or any other long-running application) as a custom miner within HiveOS. This allows you to use HiveOS flight sheets to start, stop, and monitor your application.

These scripts are designed to be a robust framework that calls your own custom start and stop scripts, handling the complexities of HiveOS integration, process management, and logging.

## Features

-   **Full HiveOS Integration:** Uses the modern `h-manifest.conf` method for custom miners.
-   **Clean Start/Stop:** Reliably starts your application when the flight sheet is launched and stops it when the flight sheet is stopped.
-   **Robust Process Management:** Includes a trap for clean shutdowns and logic to prevent hanging processes from interfering with miner restarts.
-   **Correct User Context:** Runs your scripts as a non-root user (`octa`) from the correct working directory.
-   **Logging:** Creates a log file for debugging purposes at `/home/octa/UltimatComfy/debugFlight.log`.
-   **Basic Stats:** Reports basic uptime and a dummy hashrate to the HiveOS agent.

## Installation and Usage

### 1. Prerequisites

This framework assumes you have two scripts of your own:
-   A start script, located at `/home/octa/comfyui_unified_setup/scripts/start_comfyui.sh`
-   A stop script, located at `/home/octa/comfyui_unified_setup/scripts/stop_comfyui.sh`

The framework also assumes your application's main working directory is `/home/octa/UltimatComfy`. If these paths are different, you will need to edit `h-run.sh` to reflect your custom paths.

### 2. Configuring the HiveOS Flight Sheet

1.  Navigate to the **Releases** page of this repository and copy the URL for the latest `.tar.gz` package.
2.  In HiveOS, create a new **Flight Sheet**.
3.  For the miner, select **"Custom"**.
4.  Click **"Setup Miner Config"**.
5.  A new window will appear. Fill in the following fields:
    -   **Miner name:** Enter the name of the miner as specified in the release file name (e.g., `v9ComfyUISheet`).
    -   **Installation URL:** Paste the `.tar.gz` URL you copied from the GitHub release.
6.  Apply changes, save the flight sheet, and launch it.

## Troubleshooting

-   The primary log file for this framework is located on your rig at `/home/octa/UltimatComfy/debugFlight.log`. If the miner starts but your application doesn't, check this log first.
-   If the framework itself is failing, the HiveOS agent log will contain details (as seen during our debugging).
-   Most application-specific issues will be related to your `start_comfyui.sh` and `stop_comfyui.sh` scripts or the environment of the `octa` user. The framework is responsible only for calling these scripts correctly.
