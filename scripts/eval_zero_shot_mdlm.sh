#!/bin/bash
# Reproduce MDLM Table 3: Zero-shot perplexities on 7 datasets
# Model: MDLM trained on OWT (kuleshov-group/mdlm-owt from HuggingFace)
#
# Expected perplexities from Table 3:
#   PTB:             95.26
#   Wikitext-103:    32.83
#   LM1B:            67.01
#   Lambada:         47.52
#   AG News:         61.15
#   Pubmed:          41.89
#   Arxiv:           37.37
#
# Usage:
#   bash scripts/eval_zero_shot_mdlm.sh          # run all datasets
#   bash scripts/eval_zero_shot_mdlm.sh ptb      # run single dataset

set -e
export HYDRA_FULL_ERROR=1

CHECKPOINT=kuleshov-group/mdlm-owt
BACKBONE=hf_dit
PARAM=subs
SEQ_LEN=1024
BATCH_SIZE=16

ALL_DATASETS=(
  ptb
  wikitext103
  lm1b-gpt2
  lambada
  ag_news
  scientific_papers_pubmed
  scientific_papers_arxiv
)

# If a dataset argument is given, only evaluate that one
if [ -n "$1" ]; then
  DATASETS=("$1")
else
  DATASETS=("${ALL_DATASETS[@]}")
fi

echo "============================================"
echo "MDLM Zero-Shot Perplexity Evaluation"
echo "Table 3 Reproduction"
echo "============================================"

for name in "${DATASETS[@]}"; do
  echo ""
  echo ">>> Evaluating on: $name"
  echo "--------------------------------------------"

  python main.py \
    mode=ppl_eval \
    loader.batch_size=$BATCH_SIZE \
    loader.eval_batch_size=$BATCH_SIZE \
    data=$name \
    model=small \
    parameterization=$PARAM \
    backbone=$BACKBONE \
    model.length=$SEQ_LEN \
    eval.checkpoint_path=$CHECKPOINT \
    +wandb.offline=true

  echo ">>> Done: $name"
  echo "--------------------------------------------"
done

echo ""
echo "============================================"
echo "All evaluations complete!"
echo "============================================"
