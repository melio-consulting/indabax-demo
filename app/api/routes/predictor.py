from typing import Any

import numpy as np
import joblib
from fastapi import APIRouter, HTTPException
from loguru import logger

from models.prediction import (
    HealthResponse,
    MachineLearningResponse,
    MachineLearningDataInput,
)
from services.predict import MachineLearningModelHandlerScore as model
from core.errors import PredictException

router = APIRouter()


@router.post(
    "/predict", response_model=MachineLearningResponse, name="predict:get-data"
)
async def predict(data_input: MachineLearningDataInput):
    if not data_input:
        raise HTTPException(status_code=404, detail=f"'data_input' argument invalid!")
    try:

        ## Change this portion for other types of models
        data_point = data_input.get_np_array()

        logger.info(f"input: {data_point}")
        prediction = model.predict(
            data_point, load_wrapper=joblib.load, method="predict"
        )
        logger.info(f"prediction: {prediction}")

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Exception: {e}")

    return MachineLearningResponse(prediction=prediction)


@router.get(
    "/health",
    response_model=HealthResponse,
    name="health:get-data",
)
async def health():
    is_health = False
    try:
        get_prediction("lorem ipsum")
        is_health = True
        return HealthResponse(status=is_health)
    except Exception:
        raise HTTPException(status_code=404, detail="Unhealthy")
