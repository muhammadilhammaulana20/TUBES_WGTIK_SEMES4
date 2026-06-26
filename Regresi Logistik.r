# ============================================================
# PROYEK DATA DENGAN R (CLO-6) - TELKOM UNIVERSITY
# Judul   : Klasifikasi Nasabah Bank (Bank Marketing)
# Metode  : Regresi Logistik
# Dataset : bank.csv (11.162 observasi, 17 variabel)
# ============================================================

# --- 1. LOAD LIBRARY ---
library(ggplot2)
library(dplyr)
library(caret)
library(pROC)
library(gridExtra)

# --- 2. LOAD DATA ---
df <- read.csv("bank.csv", stringsAsFactors = FALSE)

cat("Jumlah baris  :", nrow(df), "\n")
cat("Jumlah kolom  :", ncol(df), "\n")
cat("Missing value :", sum(is.na(df)), "\n\n")
summary(df)

# Distribusi target
cat("Distribusi Deposit:\n")
print(prop.table(table(df$deposit)) * 100)

# --- 3. VISUALISASI EDA ---

# Plot 1: Distribusi deposit
p1 <- ggplot(df, aes(x = deposit, fill = deposit)) +
  geom_bar(width = 0.5) +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  labs(title = "Gambar 1. Distribusi Target (Deposit)",
       x = "Deposit", y = "Jumlah") +
  theme_minimal() + theme(legend.position = "none")

# Plot 2: Usia vs Deposit
p2 <- ggplot(df, aes(x = deposit, y = age, fill = deposit)) +
  geom_boxplot() +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  labs(title = "Gambar 2. Usia vs Deposit",
       x = "Deposit", y = "Usia") +
  theme_minimal() + theme(legend.position = "none")

# Plot 3: Saldo vs Deposit
p3 <- ggplot(df, aes(x = deposit, y = balance, fill = deposit)) +
  geom_boxplot(outlier.alpha = 0.3) +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  coord_cartesian(ylim = c(-500, 8000)) +
  labs(title = "Gambar 3. Saldo vs Deposit",
       x = "Deposit", y = "Saldo (EUR)") +
  theme_minimal() + theme(legend.position = "none")

# Plot 4: Durasi Panggilan vs Deposit
p4 <- ggplot(df, aes(x = deposit, y = duration, fill = deposit)) +
  geom_boxplot(outlier.alpha = 0.3) +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  labs(title = "Gambar 4. Durasi Panggilan vs Deposit",
       x = "Deposit", y = "Durasi (detik)") +
  theme_minimal() + theme(legend.position = "none")

grid.arrange(p1, p2, p3, p4, ncol = 2)

# Plot 5: Proporsi deposit per pekerjaan
df %>%
  count(job, deposit) %>%
  group_by(job) %>%
  mutate(pct = n / sum(n)) %>%
  ggplot(aes(x = reorder(job, pct), y = pct, fill = deposit)) +
  geom_bar(stat = "identity") + coord_flip() +
  scale_fill_manual(values = c("yes" = "#1565C0", "no" = "#C62828")) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Gambar 5. Proporsi Deposit berdasarkan Pekerjaan",
       x = "Pekerjaan", y = "Proporsi") +
  theme_minimal()

# --- 4. PREPROCESSING ---
df_model <- df %>%
  mutate(
    deposit   = as.integer(deposit == "yes"),
    default   = as.integer(default == "yes"),
    housing   = as.integer(housing == "yes"),
    loan      = as.integer(loan == "yes"),
    education = case_when(education == "primary"   ~ 1,
                          education == "secondary" ~ 2,
                          education == "tertiary"  ~ 3, TRUE ~ 0),
    prev_contact = as.integer(pdays != -1),
    month    = match(tolower(month),
                     c("jan","feb","mar","apr","may","jun",
                       "jul","aug","sep","oct","nov","dec")),
    job      = as.integer(factor(job)),
    marital  = as.integer(factor(marital)),
    contact  = as.integer(factor(contact)),
    poutcome = as.integer(factor(poutcome))
  ) %>% select(-pdays)

cat("\nStruktur data setelah preprocessing:\n")
str(df_model)

# --- 5. SPLIT DATA TRAIN 80% : TEST 20% ---
set.seed(42)
idx        <- createDataPartition(df_model$deposit, p = 0.8, list = FALSE)
data_train <- df_model[idx, ]
data_test  <- df_model[-idx, ]

cat("\nData latih:", nrow(data_train), "| Data uji:", nrow(data_test), "\n")

# --- 6. MODEL REGRESI LOGISTIK ---
model <- glm(deposit ~ ., data = data_train, family = binomial())
cat("\n=== RINGKASAN MODEL ===\n")
summary(model)

# Odds Ratio
cat("\n--- Odds Ratio ---\n")
print(round(exp(cbind(OR = coef(model),
                      suppressMessages(confint(model)))), 3))

# --- 7. PREDIKSI & EVALUASI ---
prob  <- predict(model, newdata = data_test, type = "response")
pred  <- factor(ifelse(prob >= 0.5, 1, 0), levels = c(0,1))
aktual <- factor(data_test$deposit, levels = c(0,1))

cm <- confusionMatrix(pred, aktual, positive = "1")
cat("\n=== CONFUSION MATRIX ===\n")
print(cm)

# Plot Confusion Matrix
as.data.frame(cm$table) %>%
  ggplot(aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), size = 8, fontface = "bold", color = "white") +
  scale_fill_gradient(low = "#90CAF9", high = "#1565C0") +
  labs(title = "Gambar 6. Confusion Matrix – Regresi Logistik",
       x = "Aktual", y = "Prediksi") +
  theme_minimal(base_size = 13) + theme(legend.position = "none")

# ROC Curve & AUC
roc_obj <- roc(data_test$deposit, prob, quiet = TRUE)
plot(roc_obj, col = "#1565C0", lwd = 2.5,
     main = "Gambar 7. ROC Curve – Regresi Logistik")
abline(a = 0, b = 1, lty = 2, col = "gray")
legend("bottomright",
       legend = sprintf("AUC = %.3f", auc(roc_obj)),
       col = "#1565C0", lwd = 2, bty = "n")

# Ringkasan Metrik
cat("\n╔══════════════════════════╗\n")
cat("║    HASIL EVALUASI MODEL  ║\n")
cat("╠══════════════════════════╣\n")
cat(sprintf("║ Akurasi  : %6.2f%%       ║\n", cm$overall["Accuracy"]*100))
cat(sprintf("║ Presisi  : %6.2f%%       ║\n", cm$byClass["Precision"]*100))
cat(sprintf("║ Recall   : %6.2f%%       ║\n", cm$byClass["Recall"]*100))
cat(sprintf("║ F1-Score : %6.2f%%       ║\n", cm$byClass["F1"]*100))
cat(sprintf("║ AUC      : %6.3f         ║\n", auc(roc_obj)))
cat("╚══════════════════════════╝\n")

