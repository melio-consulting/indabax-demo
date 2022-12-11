from pydantic import BaseModel
from typing import Optional
import numpy as np


class MachineLearningResponse(BaseModel):
    prediction: float


class HealthResponse(BaseModel):
    status: bool


class MachineLearningDataInput(BaseModel):
    alcohol: float
    malic_acid: float
    ash: float
    alcalinity_of_ash: float
    magnesium: float
    total_phenols: float
    flavanoids: float
    nonflavanoid_phenols: float
    proanthocyanins: float
    color_intensity: float
    hue: float
    od280_od315_of_diluted_wines: float
    proline: float

    def get_np_array(self):
        return np.array(
            [
                [
                    self.alcohol,
                    self.malic_acid,
                    self.ash,
                    self.alcalinity_of_ash,
                    self.magnesium,
                    self.total_phenols,
                    self.flavanoids,
                    self.nonflavanoid_phenols,
                    self.proanthocyanins,
                    self.color_intensity,
                    self.hue,
                    self.od280_od315_of_diluted_wines,
                    self.proline,
                ]
            ]
        )
