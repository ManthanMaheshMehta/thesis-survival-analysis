# thesis-survival-analysis
Master’s Thesis: Comparing Traditional and Machine Learning Survival Analysis Methods

# Survival Prediction in AIDS Patients

**Master’s Thesis: Comparing Traditional and Machine Learning-Based Survival Models**

This project compares traditional survival analysis (Cox Proportional Hazards) with machine learning models (Random Survival Forest and Gradient Boosting Machine) to predict survival outcomes among AIDS patients using data from ACTG Study 175.

🧪 Built an interactive risk prediction dashboard using R Shiny  
📊 Evaluated models using Concordance Index (C-index)  
🛠️ Analysis performed using **R (v4.3.1)** and **SAS (v9.4)**  
💡 Highlighted clinical usability alongside predictive performance

---

## 📂 Data & Methods

- **Dataset**: AIDS Clinical Trials Group Study 175 (ACTG 175), including 2,139 patients
- **Outcome**: Time to death or censoring (survival time)
- **Predictors**: Age, gender, race, Karnofsky score, CD8 counts, symptom status, ZDV exposure, treatment group, and more

### 🧮 Methods Used
- **Traditional Model**: Cox Proportional Hazards (with stratification)
- **Machine Learning Models**: Random Survival Forest (RSF), Gradient Boosting Machine (GBM)
- **Software**:  
  - **SAS**: Data exploration, descriptive stats, Kaplan-Meier curves  
  - **R**: Survival modeling, ML analysis, interactive dashboard

- **Evaluation Metric**: Concordance Index (C-index) to compare model accuracy
