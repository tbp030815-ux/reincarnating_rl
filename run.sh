#!/bin/bash

# List of 10 Atari games from the paper (inferred from common subsets and code examples)
GAMES=("Enduro" "MsPacman" "Bowling" "Riverraid")

# Number of seeds per game
SEEDS=(1)

# Number of available GPUs (adjust based on your system)
NUM_GPUS=1

# 当前的GPU的ID
CUR_GPU=3

# 当前的模型名称
CUR_AGENT="QDagger"

# Base command template (without variables)
BASE_COMMAND="python -um reincarnating_rl.train \
  --agent=qdagger_rainbow \
  --gin_files=reincarnating_rl/configs/qdagger_rainbow.gin \
  --gin_bindings=Runner.num_iterations=10 \
  --gin_bindings=RunnerWithTeacher.num_pretraining_iterations=10 \
  --gin_bindings=RunnerWithTeacher.num_pretraining_steps=100000 \
  --gin_bindings=atari_lib.create_atari_environment.sticky_actions=True \
  --teacher_agent=dqn \
  --teacher_checkpoint_file_prefix=ckpt \
  --disable_jit=False"

# Loop over games
for GAME in "${GAMES[@]}"; do
  # Loop over seeds
  for SEED in "${SEEDS[@]}"; do
    # Calculate GPU ID (cycle through GPUs)
    GPU_ID=$(( (${#GAMES[@]} * (SEED - 1) + ${#GAMES[@]}) % NUM_GPUS + CUR_GPU))

    # Set variables for this run
    BASE_DIR="./reincarnating_rl/logs/figure2/panel1/${CUR_AGENT}/${GAME}/run_${SEED}"
    GAME_BINDING="--gin_bindings=atari_lib.create_atari_environment.game_name=\"${GAME}\""
    TEACHER_DIR="./reincarnating_rl/teacher_ckpt/${GAME}/1"
    TEACHER_CHECKPOINT="--teacher_checkpoint_dir=${TEACHER_DIR}"
    TEACHER_NUMBER="--teacher_checkpoint_number=399"
    RUN_NUMBER="--run_number=${SEED}"
    BASE_DIR_OPT="--base_dir=${BASE_DIR}"

    # Create the directory if it doesnt exist
    mkdir -p "${BASE_DIR}"

    # Run the command in background
    CUDA_VISIBLE_DEVICES=${GPU_ID} ${BASE_COMMAND} \
      ${BASE_DIR_OPT} \
      ${GAME_BINDING} \
      ${TEACHER_CHECKPOINT} \
      ${TEACHER_NUMBER} \
      ${RUN_NUMBER} &

    # Wait if we've launched NUM_GPUS jobs to avoid overload
    if [ $(( (${#GAMES[@]} * SEED + ${#GAMES[@]}) % NUM_GPUS )) -eq 0 ]; then
      wait
    fi
  done
done

# Wait for all remaining jobs to finish
wait

echo "All experiments completed."