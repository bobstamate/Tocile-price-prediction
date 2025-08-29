library(readxl)
library(boot)

# read file
df <- read_excel("/Users/bogdanstamate/Desktop/OLXTocile_iul25.xlsx")
df_clean <- df[, c("Preț (EUR)", "Număr Camere", "Suprafață Utilă (mp)", "Suprafață Teren (mp)")]
df_clean <- na.omit(df_clean)

# Regression coefficients
regresie <- function(data, indices) {
  sample <- data[indices, ]
  model <- lm(`Preț (EUR)` ~ `Număr Camere` + `Suprafață Utilă (mp)` + `Suprafață Teren (mp)`, data = sample)
  return(coef(model))
}

# Bootstrap 1000 resamples
set.seed(123)
rez_boot <- boot(data = df_clean, statistic = regresie, R = 500)

# Simulation of a new house
# Ex: 4 camere, 160 mp utili, 860 mp teren
new_house <- c(1, 4, 150, 860)

# Bootstrap prediction
pred_bootstrap <- rez_boot$t %*% new_house  # matrice coef * vector caracteristici

# mean + confidence interval 95%
mean_pred <- mean(pred_bootstrap)
ci_pred <- quantile(pred_bootstrap, probs = c(0.025, 0.975))

cat("Predicție medie:", round(mean_pred), "EUR\n")
cat("Interval de încredere 95%: [", round(ci_pred[1]), ",", round(ci_pred[2]), "] EUR\n")

# null hypothesis: mean price is 238.000 EUR
mu0 <- 238000


boot_mean <- mean(pred_bootstrap)

# bootstrap p-value
p_val <- mean(pred_bootstrap <= mu0)

cat("P-value bootstrap (H0: μ =", mu0, "):", round(p_val, 4), "\n")

hist_data <- hist(pred_bootstrap, breaks = 30, plot = FALSE)

# histogram graphics
plot(hist_data, 
     main = paste("Prediction distribution\np-value vs", mu0, " EUR"),
     xlab = "Estimate price(EUR)",
     col = "lightgray", border = "white")

# show p-value on graph in orange (extreme values)
for (i in 1:(length(hist_data$breaks) - 1)) {
  xleft <- hist_data$breaks[i]
  xright <- hist_data$breaks[i + 1]
  
  if (abs(xleft - boot_mean) >= abs(mu0 - boot_mean) | abs(xright - boot_mean) >= abs(mu0 - boot_mean)) {
    rect(xleft, 0, xright, hist_data$counts[i], col = "orange", border = NA)
  }
}


plot(hist_data, add = TRUE, col = NA, border = "black")
q95 <- quantile(pred_bootstrap, 0.05)
abline(v = boot_mean, col = "red", lwd = 2, lty = 2)
abline(v = mu0, col = "blue", lwd = 2, lty = 3)
abline(v = q95, col = "purple", lwd = 2, lty = 2)
qstat <- quantile(null_dist$stat, probs = 0.05)
geom_vline(xintercept = qstat, size=2,linetype = 2)

legend("topright",
       legend = c("Bootstrap Mean", "null hypothesis", "p-value area"),
       col = c("red", "blue", "orange"),
       lty = c(2, 3, NA),
       fill = c(NA, NA, "orange"),
       border = NA,
       bty = "n")

