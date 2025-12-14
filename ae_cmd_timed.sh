# Figure 5
cd /root/step_artifact/
mv step-perf/src/memory/mod.rs step-perf/src/memory/bw_64_mod.rs
mv step-perf/src/memory/hdl_mod.rs step-perf/src/memory/mod.rs
source setup.sh
time pytest hdl_validation/expert_tiling_sweep.py::test_expert_tiling_sweep_single_schedule
mv step-perf/src/memory/mod.rs step-perf/src/memory/hdl_mod.rs
mv step-perf/src/memory/bw_64_mod.rs step-perf/src/memory/mod.rs
source setup.sh
echo "figure 5 done"
# Produced file: step_artifact/hdl_validation/fig5.csv


# Figure 6
cd /root/step_artifact/
time pytest dyn_tiling/test_mixtral_sweep.py::test_mixtral_b64
# Produced file: step_artifact/dyn_tiling/figure_6_mixtral_b64.csv

time pytest dyn_tiling/test_qwen_sweep.py::test_qwen_b64
# Produced file: step_artifact/dyn_tiling/figure_6_qwen_b64.csv

echo "figure 6 done"

# Figure 7
cd /root/step_artifact/
time pytest dyn_tiling/test_mixtral_sweep_prefill.py::test_mixtral_b1024
# Produced file: step_artifact/dyn_tiling/figure_7_mixtral_b1024.csv

time pytest dyn_tiling/test_qwen_sweep_prefill.py::test_qwen_b1024
# Produced file: step_artifact/dyn_tiling/figure_7_qwen_b1024.csv

echo "figure 7 done"

# Figure 8 & 9
cd /root/step_artifact/
time pytest timeshare_mem_bound/test_membound_qwen_sweep_revet.py::test_static_tile
# Produced files: step_artifact/timeshare_mem_bound/fig_8_a.csv, 
#                 step_artifact/timeshare_mem_bound/fig_9_a.csv,
#                 step_artifact/timeshare_mem_bound/fig_9_b.csv
python timeshare_mem_bound/generate_fig8.py 
# Produced file: step_artifact/timeshare_mem_bound/figure8.pdf

time pytest timeshare_mem_bound/test_membound_qwen_sweep_dyn_tile.py::test_dyn_tile
# Produced files: step_artifact/timeshare_mem_bound/fig_8_b.csv
python timeshare_mem_bound/generate_fig9.py 
# Produced file: step_artifact/timeshare_mem_bound/figure9.pdf


echo "figure 8 & 9 done"

# Figure 11
cd /root/step_artifact/
time pytest dynamic_par/sweep_ae.py::test_b16_sweep
# Produced file: step_artifact/dynamic_par/batch16_sweep_ae.csv

time pytest dynamic_par/sweep_ae.py::test_b64_sweep
# Produced file: step_artifact/dynamic_par/batch64_sweep_ae.csv

time pytest dynamic_par/sweep_ae.py::test_b64_b16_sweep
# Produced file: step_artifact/dynamic_par/batch80_sweep_ae.csv


echo "figure 11 done"