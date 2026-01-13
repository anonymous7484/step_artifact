# Figure 5 (2m)
cd /root/step_artifact/
source ./hdl_validation/figure5_step.sh  
# Produced file: step_artifact/hdl_validation/fig5.csv


# Figure 6 (30m, 46m)
cd /root/step_artifact/
pytest dyn_tiling/test_mixtral_sweep.py::test_mixtral_b64
# Produced file: step_artifact/dyn_tiling/figure_6_mixtral_b64.csv

pytest dyn_tiling/test_qwen_sweep.py::test_qwen_b64
# Produced file: step_artifact/dyn_tiling/figure_6_qwen_b64.csv

python dyn_tiling/generate_fig6.py
# Produced file: step_artifact/dyn_tiling/figure6.pdf
# Produced file: step_artifact/dyn_tiling/figure6.png

echo "figure 6 done"

# Figure 7 (72m, 71m)
cd /root/step_artifact/
pytest dyn_tiling/test_mixtral_sweep_prefill.py::test_mixtral_b1024
# Produced file: step_artifact/dyn_tiling/figure_7_mixtral_b1024.csv

pytest dyn_tiling/test_qwen_sweep_prefill.py::test_qwen_b1024
# Produced file: step_artifact/dyn_tiling/figure_7_qwen_b1024.csv

python dyn_tiling/generate_fig7.py
# Produced file: step_artifact/dyn_tiling/figure7.pdf
# Produced file: step_artifact/dyn_tiling/figure7.png

echo "figure 7 done"

# --------------------------------------------------------------------
# Figure 12 & 13 (48m, 52m)
cd /root/step_artifact/
pytest timeshare_mem_bound/test_membound_qwen_sweep_revet.py::test_static_tile
# Produced files: step_artifact/timeshare_mem_bound/fig_8_a.csv, 
#                 step_artifact/timeshare_mem_bound/fig_9_a.csv,
#                 step_artifact/timeshare_mem_bound/fig_9_b.csv

pytest timeshare_mem_bound/test_membound_qwen_sweep_dyn_tile.py::test_dyn_tile
# Produced files: step_artifact/timeshare_mem_bound/fig_8_b.csv

python timeshare_mem_bound/generate_fig12.py 
# Produced file: step_artifact/timeshare_mem_bound/figure12.pdf
python timeshare_mem_bound/generate_fig13.py 
# Produced file: step_artifact/timeshare_mem_bound/figure13.pdf


echo "figure 12 & 13 done"
# --------------------------------------------------------------------
# Figure 21 (1m39s, 4m50s, 6m31s)
cd /root/step_artifact/
pytest dynamic_par/sweep_ae.py::test_b16_sweep
# Produced file: step_artifact/dynamic_par/batch16_sweep_ae.csv

pytest dynamic_par/sweep_ae.py::test_b64_sweep
# Produced file: step_artifact/dynamic_par/batch64_sweep_ae.csv

pytest dynamic_par/sweep_ae.py::test_b64_b16_sweep
# Produced file: step_artifact/dynamic_par/batch80_sweep_ae.csv

python dynamic_par/fig21_change_scale.py
# Produced file: step_artifact/dynamic_par/figure21.pdf
echo "figure 21 done"


# --------------------------------------------------------------------
echo "figure 14 start"

pytest dynamic_par/sweep_ae_revision.py::test_b64_sweep # 3m30s
python dynamic_par/fig_interleave_dyn.py
# Produced file: step_artifact/dynamic_par/figure14.pdf

echo "figure 14 done"
# --------------------------------------------------------------------
echo "figure 15 start"

pytest dynamic_par/sweep_ae_revision.py::test_batch_sweep # 1m
python dynamic_par/fig_coarse_dyn_64.py
# Produced file: step_artifact/dynamic_par/figure15.pdf

echo "figure 15 done"


# --------------------------------------------------------------------