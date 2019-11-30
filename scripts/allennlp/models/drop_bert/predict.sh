#!/usr/bin/env

# PACKAGE TO BE INCLUDED WHICH HOUSES ALL THE CODE
INCLUDE_PACKAGE=semqa
export GPU=0
export BEAMSIZE=1
export DEBUG=true

# SAVED MODEL
MODEL_DIR=./resources/semqa/checkpoints/drop/date_num/iclr_1200/drop_parser_bert/EXCLOSS_true/MMLLOSS_true/aux_true/SUPEPOCHS_5/S_1/IclrData-HardEM5-SentFilter
MODEL_TAR=${MODEL_DIR}/model.tar.gz
PREDICTION_DIR=${MODEL_DIR}/predictions
mkdir ${PREDICTION_DIR}

DATASET_DIR=./resources/data/drop_post_iclr
DATASET_NAME=date_num/iclr_1200

FULL_VALFILE=${DATASET_DIR}/${DATASET_NAME}/drop_dataset_dev.json

# Prediction output including verbose execution logs
PREDICTOR=drop_parser_predictor
PREDICTION_FILE=${PREDICTION_DIR}/drop_dev_verbose_preds.txt

# Prediction output in a JSON-L file similar to MTMSN
#PREDICTOR=drop_mtmsnstyle_predictor
#PREDICTION_FILE=${PREDICTION_DIR}/drop_dev_preds.jsonl

allennlp predict --output-file ${PREDICTION_FILE} \
                 --predictor ${PREDICTOR} \
                 --cuda-device ${GPU} \
                 --include-package ${INCLUDE_PACKAGE} \
                 --silent \
                 --batch-size 4 \
                 --use-dataset-reader \
                 --overrides "{"model": { "beam_size": ${BEAMSIZE}, "debug": ${DEBUG}}}" \
                 ${MODEL_TAR} ${FULL_VALFILE}

echo -e "Dev predictions file saved at: ${PREDICTION_FILE}"
