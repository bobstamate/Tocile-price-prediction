# Tocile House Price Prediction

This project contains an R script that estimates house prices in the village of Tocile, Romania, using linear regression combined with bootstrap simulations. I gathered the data using a Chrome extension and searching through the best known real estate page in Romania, exported the relevant parameters in an Excel file and using R to estimate a price range. The idea to do this came after long discussions with my family about how we can set a fair price to sell the house.

## What the script does

- Loads house listings from OLX (exported to Excel)
- Cleans and prepares relevant variables:  
  - Price (EUR)  
  - Number of rooms  
  - Useful surface (sqm)  
  - Land surface (sqm)
- Builds a linear regression model to estimate prices
- Uses bootstrap resampling to simulate price predictions and confidence intervals
- Visualizes the distribution of predictions and marks the test hypothesis against a reference price

## Statistical methods used

- **Linear Regression**: Estimates coefficients for predictors based on available data
- **Bootstrap (500 samples)**: Resamples the data to assess variability in the price estimates
- **Hypothesis testing**: Calculates a one-tailed p-value to test whether the predicted price is significantly lower than a benchmark (e.g., €238,000)

## How to use

1. Open the `TocilePricePrediction.R` script in R or RStudio
2. Adjust the path to your Excel file if needed
3. Run the script
4. Check the console output and the generated histogram for results

## Output example

- Predicted average price: ~250,000 EUR
- 95% Confidence Interval: [230,000 EUR, 270,000 EUR]
- One-tailed p-value: 0.0342 (indicating the price is significantly lower than €238,000)

## Requirements

- R
- Packages: `readxl`, `boot`

---

**Author**: Bogdan Stamate  
**Note**: This is a personal exploratory project and not intended for production use.
