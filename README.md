# 🧠 Disease Prediction using Logistic Regression (MATLAB)

A Machine Learning project using MATLAB to predict diabetes using Logistic Regression and SVM. Includes GUI, accuracy metrics, and confusion matrix.

## 📂 Dataset

We use the **Pima Indians Diabetes Dataset**:

- **Filename**: `diabetes_dataset.csv`  
- **Source**: [Kaggle - Pima Indians Diabetes Database](https://www.kaggle.com/datasets/uciml/pima-indians-diabetes-database)  
- **Inputs**:
  - Pregnancies
  - Glucose
  - BloodPressure
  - SkinThickness
  - Insulin
  - BMI
  - DiabetesPedigreeFunction
  - Age

> ⚠️ Place the CSV file in your MATLAB working directory before running the code.

---

## 🚀 Project Features

- ✅ Data Preprocessing & Normalization  
- ✅ Logistic Regression & SVM Model Training  
- ✅ Accuracy & Confusion Matrix Reporting  
- ✅ Simple GUI for live predictions  
- ✅ Tailored for Biomedical Engineering 4th semester students

---

## 🧪 How It Works

1. Run `disease_prediction_main.m`
   - Loads dataset
   - Preprocesses input features
   - Splits data into training/testing
   - Trains **Logistic Regression** and **SVM**
   - Evaluates accuracy and shows confusion matrix

2. Use `disease_predictor_gui.m` to:
   - Enter 8 health parameters manually
   - Predict diabetes status using saved model
   - See result instantly in the GUI

---

## 📊 Sample Confusion Matrix (Logistic Regression)

```
Predicted →
            0      1
Actual ↓
0         40      10  
1         8       30  
```

- **Accuracy**: ~79.74%  
- (Sample output; may vary based on dataset split)

---

## 📁 Project Structure

```
DiseasePredictionProject/
│
├── diabetes_dataset.csv
├── disease_prediction_main.m
├── train_logistic_model.m
├── train_svm_model.m
├── evaluate_model.m
├── disease_predictor_gui.m
├── logistic_model.mat
├── svm_model.mat
└── README.md
```

---

## 📌 Requirements

- MATLAB R2021a or later  
- Statistics and Machine Learning Toolbox  

---

## 📘 License

This project is open for educational use only. Not intended for medical decision-making.

---

## 🙋‍♂️ Maintainer

A GUI-based MATLAB project developed by me for Biomedical Engineering students to understand and implement disease prediction using machine learning techniques.
