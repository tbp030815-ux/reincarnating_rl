@echo off
echo Starting Reincarnating RL Training...
set CUDA_VISIBLE_DEVICES=0
python -um reincarnating_rl_old.train ^
  --agent=distillation_dqn ^
  --base_dir=./reincarnating_rl_old/logs/distillation_dqn/Breakout/run_1 ^
  --gin_files=./reincarnating_rl_old/configs/distillation_dqn.gin ^
  --run_number=1 ^
  --gin_bindings=atari_lib.create_atari_environment.game_name=\"Breakout\" ^
  --gin_bindings=Runner.num_iterations=20 ^
  --teacher_checkpoint_dir=./reincarnating_rl_old/teacher_ckpt/Breakout/1/checkpoints ^
  --teacher_checkpoint_number=399 ^
  --disable_jit=False