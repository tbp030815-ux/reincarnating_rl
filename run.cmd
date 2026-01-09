@echo off
echo Starting Reincarnating RL Training...
set CUDA_VISIBLE_DEVICES=0
python -um reincarnating_rl.train ^
  --agent=qdagger_dqn ^
  --base_dir=./reincarnating_rl/logs/qdagger_dqn/Breakout/run_2 ^
  --gin_files=./reincarnating_rl/configs/qdagger_dqn.gin ^
  --run_number=2 ^
  --gin_bindings=atari_lib.create_atari_environment.game_name=\"Breakout\" ^
  --gin_bindings=Runner.num_iterations=20 ^
  --teacher_checkpoint_dir=./reincarnating_rl/teacher_ckpt/Breakout/1 ^
  --disable_jit=False