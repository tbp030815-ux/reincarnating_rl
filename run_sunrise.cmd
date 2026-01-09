@echo off
echo Starting Reincarnating RL Training...
set CUDA_VISIBLE_DEVICES=0
python -um reincarnating_rl_sunrise.train ^
  --agent=qdagger_dqn ^
  --base_dir=./reincarnating_rl_sunrise/logs/qdagger_dqn/Bowling/run_1 ^
  --gin_files=./reincarnating_rl_sunrise/configs/qdagger_dqn.gin ^
  --run_number=1 ^
  --gin_bindings=atari_lib.create_atari_environment.game_name=\"Bowling\" ^
  --gin_bindings=Runner.num_iterations=0 ^
  --teacher_checkpoint_dir=./reincarnating_rl_sunrise/teacher_ckpt/Bowling/1 ^
  --disable_jit=False