# Respiratory-Hospitalizations-Predictions

## Purpose
Compiling respiratory hospitalization data from local hospitals within the Kingston, Ontario and Windsor, Ontario regions, I utilize different models to predict the future patient intakes for each region. The goal is to make accurate predictions in order to capture the underlying dynamics that dictate this elusive disease. By viewing how adjacent data correlates with respiratory hospitalization, such as tempurature and humidity, we can better understand what causes spikes in these severe cases.

## Methodology
The way that the predictions are made is by looking at the historic data of the previous 10-30 days and then make a prediction of the patient intake for the next day, and then to repeatedly make one day predictions for the remainder of the dataset. I utilized multiple data processing techniques, such as **DCT (Discrete Cosine Transform)**, **ICA (Independent Component Analysis)**, **SVD(Singular Value Decomposition)**, and **Linear/Exponential decomposition** to prepare the data for the models. As stated before, I also used supporting data to the patient intakes, such as local tempurature, humidity and day of the week assingment.

Models used:
* **XGBoost Decision Trees**
* **SVM (Support Vector Machine)**
* **Ensemble**

In addition to that, I also added histogram nudging. The nudging attempts to look at the previous 10-30 days of patient intakes and assess whether the prediction from the model was accurate. 

## Results
The predictions are fairly accurate, where the MAE(Mean Absolute Error) is approximately 2 for Kingston and 3 for Windsor. Meaning that for each respective region, it is only off by approximately 2 or 3 patients on average.

Kingston Prediction Results:

<img width="885" alt="Screen Shot 2022-06-15 at 4 08 30 PM" src="https://user-images.githubusercontent.com/34041631/173917884-bd81d553-9f62-4558-bed5-aea7ccf5ee99.png">

Windsor Prediction Results:

<img width="889" alt="Screen Shot 2022-06-15 at 4 11 30 PM" src="https://user-images.githubusercontent.com/34041631/173918232-59d2742d-cdc5-4326-b4dd-cb3d034919dc.png">


To see more prediction data visualizations, one can refer to the Patient_Prediction file.
