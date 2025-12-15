import os
import argparse
import subprocess

# Root inside the container
CONTAINER_ROOT = "/root"

# List of absolute paths inside the container
FILES_TO_COPY = [
    # Figure 6
    "step_artifact/dyn_tiling/figure_6_mixtral_b64.csv",
    "step_artifact/dyn_tiling/figure_6_qwen_b64.csv",
    "step_artifact/dyn_tiling/figure6.pdf",

    # Figure 7
    "step_artifact/dyn_tiling/figure_7_mixtral_b1024.csv",
    "step_artifact/dyn_tiling/figure_7_qwen_b1024.csv",
    "step_artifact/dyn_tiling/figure7.pdf",

    # Figure 8 & 9
    "step_artifact/timeshare_mem_bound/fig_8_a.csv",
    "step_artifact/timeshare_mem_bound/fig_8_b.csv",
    "step_artifact/timeshare_mem_bound/fig_9_a.csv",
    "step_artifact/timeshare_mem_bound/fig_9_b.csv",
    "step_artifact/timeshare_mem_bound/figure8.pdf",
    "step_artifact/timeshare_mem_bound/figure9.pdf",

    # Figure 11
    "step_artifact/dynamic_par/batch16_sweep_ae.csv",
    "step_artifact/dynamic_par/batch64_sweep_ae.csv",
    "step_artifact/dynamic_par/batch80_sweep_ae.csv",
    "step_artifact/dynamic_par/figure11.pdf",

    # Figure 5
    "step-artifact-eval/dse_results.csv",
    "step-artifact-eval/step_reference.csv",
    "step-artifact-eval/validation.pdf",
]


def docker_copy(docker_id, src_path, dst_path):
    """
    Copy a single file from container -> host
    """
    cmd = [
        "docker", "cp",
        f"{docker_id}:{src_path}",
        dst_path
    ]
    print("Running:", " ".join(cmd))
    subprocess.run(cmd, check=True)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Copy figure/data files from Docker container"
    )
    parser.add_argument(
        "--docker_id",
        required=True,
        help="Container name or ID (e.g., step_run)"
    )
    parser.add_argument(
        "--output_dir",
        required=True,
        help="Local directory to copy files into"
    )
    parser.add_argument(
        "--copy_log",
        required=False,
        help="whether to copy log"
    )
    args = parser.parse_args()

    docker_id = args.docker_id
    output_dir = os.path.abspath(args.output_dir)

    if args.copy_log is not None:
        FILES_TO_COPY.append("step_artifact/step_run.log")

    os.makedirs(output_dir, exist_ok=True)

    for rel_path in FILES_TO_COPY:
        src = os.path.join(CONTAINER_ROOT, rel_path)

        # Preserve directory structure locally
        dst = os.path.join(output_dir, rel_path)
        os.makedirs(os.path.dirname(dst), exist_ok=True)

        docker_copy(docker_id, src, dst)
