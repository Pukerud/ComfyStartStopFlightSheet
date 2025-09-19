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

Follow these steps to package and install your custom miner.

### 1. Prerequisites

This framework assumes you have two scripts of your own:
-   A start script, located at `/home/octa/comfyui_unified_setup/scripts/start_comfyui.sh`
-   A stop script, located at `/home/octa/comfyui_unified_setup/scripts/stop_comfyui.sh`

The framework also assumes your application's main working directory is `/home/octa/UltimatComfy`. If these paths are different, you will need to edit `h-run.sh` to reflect your custom paths.

### 2. Packaging the Miner

You must package the four `h-` scripts from this repository into a `.tar.gz` archive with a specific directory structure.

1.  **Download the files:** Get the latest versions of `h-manifest.conf`, `h-run.sh`, `h-stats.sh`, and `h-config.sh`.
2.  **Create a directory:** On your local computer, create a new folder. The name you choose will be your miner's name in HiveOS (e.g., `ComfyMiner`).
3.  **Copy files:** Place the four `h-` script files directly inside the directory you just created.
4.  **Create the archive:** From the directory *containing* your new folder (e.g., from your Desktop if `ComfyMiner` is on your Desktop), run the following command. Replace `ComfyMiner` with the name you chose.
    ```bash
    tar -czvf ComfyMiner.tar.gz ComfyMiner
    ```
    This creates the archive with the required internal directory structure (`ComfyMiner/h-run.sh`, etc.).

### 3. Creating a GitHub Release

1.  Navigate to the **Releases** page of your GitHub repository.
2.  Click **"Draft a new release"**.
3.  Give the release a tag/version (e.g., `v1.0`).
4.  Upload the `ComfyMiner.tar.gz` file you just created as a binary asset.
5.  Publish the release.

### 4. Configuring the HiveOS Flight Sheet

1.  In HiveOS, create a new **Flight Sheet**.
2.  For the miner, select **"Custom"**.
3.  Click **"Setup Miner Config"**.
4.  A new window will appear. Fill in the following fields:
    -   **Miner name:** Enter the exact name you used for your folder and archive (e.g., `ComfyMiner`).
    -   **Installation URL:** Go to your GitHub release page, right-click on your `.tar.gz` asset, and copy the link address. Paste this URL here.
5.  Apply changes, save the flight sheet, and launch it.

## Troubleshooting

-   The primary log file for this framework is located on your rig at `/home/octa/UltimatComfy/debugFlight.log`. If the miner starts but your application doesn't, check this log first.
-   If the framework itself is failing, the HiveOS agent log will contain details (as seen during our debugging).
-   Most application-specific issues will be related to your `start_comfyui.sh` and `stop_comfyui.sh` scripts or the environment of the `octa` user. The framework is responsible only for calling these scripts correctly.
