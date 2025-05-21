# Load Required Libraries
library(survminer)         # For beautiful Kaplan-Meier plots
library(survival)          # For survival models (Cox, KM)
library(ggplot2)           # For custom plotting
library(randomForestSRC)   # For Random Survival Forest modeling
library(ggRandomForests)   # For RSF visualizations
library(partykit)          # For interpretable survival trees
library(gbm)               # For Gradient Boosting Machine
library(pec)               # For prediction error curves
library(survAUC)           # For C-index and model comparison

#  Load the dataset
aids_data <- read.csv("AIDS_Clinical_Trials_Study_175.csv")

# =======================================
#  Kaplan-Meier Survival Curve Analyses
# =======================================

# KM curve by antiretroviral history
fit_str2 <- survfit(Surv(time, cid) ~ str2, data = aids_data)
ggsurvplot(fit_str2, data = aids_data, pval = TRUE, conf.int = TRUE,
           risk.table = FALSE, title = "Kaplan-Meier Curve by Antiretroviral History",
           xlab = "Time", ylab = "Survival Probability", legend.title = "History")

# KM curve by symptom status
fit_symptom <- survfit(Surv(time, cid) ~ symptom, data = aids_data)
ggsurvplot(fit_symptom, data = aids_data, pval = TRUE, conf.int = TRUE,
           risk.table = FALSE, title = "Kaplan-Meier Curve by Symptom Status",
           xlab = "Time", ylab = "Survival Probability", legend.title = "Symptom")

# KM curve by prior non-ZDV therapy
fit_oprior <- survfit(Surv(time, cid) ~ oprior, data = aids_data)
ggsurvplot(fit_oprior, data = aids_data, pval = TRUE, conf.int = TRUE,
           risk.table = FALSE, title = "Kaplan-Meier Curve by Prior Non-ZDV Therapy",
           xlab = "Time", ylab = "Survival Probability", legend.title = "Prior Therapy")

# ==================================================
# Cox Proportional Hazards Model + PH Assumption
# ==================================================

# Full Cox model with many predictors
cox_model <- coxph(Surv(time, cid) ~ trt + age + wtkg + karnof + race + gender +
                     cd40 + cd420 + cd80 + cd820 + str2 + symptom +
                     offtrt + oprior + z30, data = aids_data)

# Check proportional hazards assumption using Schoenfeld residuals
supremum_test <- cox.zph(cox_model)
print(supremum_test)

# Check for multicollinearity between key variables
cor(aids_data$z30, aids_data$str2)
cor(aids_data$str2, aids_data$oprior)

# Cox model using z30 (recent ZDV use) with stratification
cox_model_z30 <- coxph(Surv(time, cid) ~ age + wtkg + karnof + race + gender +
                         cd80 + cd820 + symptom + oprior + z30 +
                         strata(trt, offtrt), data = aids_data)
summary(cox_model_z30)

# Cox model using str2 (antiretroviral history) instead of z30
cox_model_str2 <- coxph(Surv(time, cid) ~ age + wtkg + karnof + race + gender +
                          cd80 + cd820 + symptom + oprior + str2 +
                          strata(trt, offtrt), data = aids_data)
summary(cox_model_str2)

# ===================================
#  Random Survival Forest (Full)
# ===================================

# RSF model with all available predictors
rsf_model_full <- rfsrc(Surv(time, cid) ~ age + karnof + cd420 + wtkg + cd40 + race +
                          cd80 + cd820 + symptom + oprior + trt + offtrt +
                          gender + z30,
                        data = aids_data, ntree = 1000,
                        importance = TRUE, na.action = "na.impute")

print(rsf_model_full)

# Plot variable importance
plot(gg_vimp(rsf_model_full)) +
  ggtitle("Variable Importance - Random Survival Forest (Full)")

# RSF with reduced predictors
rsf_model <- rfsrc(Surv(time, cid) ~ age + karnof + cd420 + wtkg +
                     cd40 + cd80 + cd820 + symptom + oprior + trt + offtrt,
                   data = aids_data, ntree = 1000,
                   importance = TRUE, na.action = "na.impute")

print(rsf_model)

# Plot variable importance (reduced model)
plot(gg_vimp(rsf_model)) +
  ggtitle("Variable Importance - Random Survival Forest (Reduced)")

# ==============================
#  Interpretable Survival Tree
# ==============================

# Add survival object to dataset
aids_data$SurvObj <- with(aids_data, Surv(time, cid))

# Build and plot conditional survival tree
ctree_model <- ctree(SurvObj ~ age + karnof + cd420 + wtkg +
                       cd40 + cd80 + cd820 + symptom + oprior + trt + offtrt,
                     data = aids_data)

plot(ctree_model, main = "Interpretable Survival Tree")

# ===============================
#  Gradient Boosting Machine
# ===============================

# Prepare survival object again (in case overwritten)
aids_data$SurvObj <- with(aids_data, Surv(time, cid))

# Fit GBM model for survival data
gbm_model <- gbm(
  formula = SurvObj ~ age + wtkg + karnof + race + gender + cd80 + cd820 +
    symptom + oprior + z30 + cd40 + cd420 + trt + offtrt,
  data = aids_data,
  distribution = "coxph",
  n.trees = 3000,
  interaction.depth = 3,
  shrinkage = 0.01,
  n.minobsinnode = 15,
  cv.folds = 5,
  verbose = TRUE
)

# Find optimal number of boosting iterations using cross-validation
best_iter <- gbm.perf(gbm_model, method = "cv")

# Show variable influence (importance)
summary(gbm_model, n.trees = best_iter)

# Plot variable importance
summary(gbm_model, n.trees = best_iter, plotit = TRUE, cBars = length(gbm_model$var.names))

# ==========================
#  Model Performance: C-index
# ==========================

# Predict survival probabilities from RSF at time = ~1000 days
rsf_pred <- predict(rsf_model, newdata = aids_data)$survival
rsf_timepoint <- which.min(abs(rsf_model$time.interest - 1000))  
rsf_surv_probs <- rsf_pred[, rsf_timepoint]

# C-index for RSF
rsf_cindex <- UnoC(Surv(aids_data$time, aids_data$cid),
                   Surv(aids_data$time, aids_data$cid),
                   1 - rsf_surv_probs)
print(rsf_cindex)

# Predict linear predictors from GBM
gbm_pred <- predict(gbm_model, newdata = aids_data, n.trees = best_iter, type = "response")

# C-index for GBM
gbm_cindex <- UnoC(Surv(aids_data$time, aids_data$cid),
                   Surv(aids_data$time, aids_data$cid),
                   1 - gbm_pred)
print(gbm_cindex)
