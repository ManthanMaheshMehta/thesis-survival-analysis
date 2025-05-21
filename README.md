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

---

## 🧠 Key Findings

- **RSF showed the highest predictive accuracy** (C-index: 0.616), followed closely by the Cox model (0.614)
- **Cox model was selected** for the dashboard due to better interpretability
- **Top predictors** of survival:
  - CD8 counts at baseline and 20 weeks
  - Karnofsky score
  - Symptom status
  - Recent ZDV use
- **ZDV-only therapy showed poorer survival** compared to combination therapies
- **Early treatment discontinuation** significantly reduced survival

These insights highlight the value of combining traditional and machine learning survival methods in clinical settings.

---

## 🖥️ Interactive Dashboard

An interactive risk prediction tool was developed using **R Shiny**, allowing users to input patient-specific variables and visualize personalized survival curves.

📌 *Note: The dashboard runs locally and is not deployed online yet.*  
If you'd like to see a demo, feel free to reach out!

---

## 🚧 Project Status

✅ Thesis Completed – May 2025  
✅ Code and model finalized  
🛠️ Future plan: Deploy the R Shiny app on a public server (e.g., shinyapps.io)


