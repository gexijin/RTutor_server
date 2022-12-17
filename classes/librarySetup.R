list_packages <- c(
  "remotes",
  "shiny",
  "openai",
  "tidyverse",

  "readxl",    # read Excel files
  "gridExtra",
  "tippy",
  "shinyBS",
  "shinybusy",
  "DataExplorer",  # auto EDA

  #---correlation----
  "ggfortify",
  "corrplot",
  "ggcorrplot",
  "GGally",
  "corrr",

  #---Heatmap----
  "pheatmap",
  "RColorBrewer",
  "gplots",
  "ComplexHeatmap",
  "dendextend",
  "ggalluvial",
  "d3heatmap",

  #--Clustering----
  "kernlab",
  "cluster",
  "fpc",
  "mclust",
  "dbscan",
  "factoextra",
  "ggdendro",
  "NbClust",
  "clusterGeneration",

  #--PCA--
  "ggbiplot",
  "psych",
  "pcaMethods",
  "PCA",
  "qgraph",
  "bootPCA",
  "PCAExplorer",

  #--Regression--
  "mgcv",
  "nlme",
  "caret",

  #--Classification, machine learning
  "rpart",
  "randomForest",
  "e1071",
  "nnet",
  "gbm",
  "liblinear",
  "caret",
  "ROCR",
  "klaR",
  "class",
  "neuralnet", # neural network
  "xgboost",
  "liblinear",
  "mlr",

  #---time series---
  "forecast",
  "tseries",
  "TSA",
  "xts",
  "lubridate"

  #--Data visualization--
)
#install.packages(list_packages)

remotes::install_github("gexijin/RTutor", upgrade = "never")

# Install top 5000 packages from CRAN

# list of all available packages
all <- available.packages()
all <- as.vector(all[, 1])
installed <- .packages(all.available = TRUE)
new_pacakge <- setdiff(all, installed)

# get download statistics for all CRAN packages
remotes::install_github("r-hub/cranlogs")

dls <- sapply(
  new_pacakge, #[1:1000], 
  function(p) {
    sum(cranlogs::cran_downloads(
      package = p, 
      from = "2022-01-01", 
      to = "2022-12-15"
    )$count)
  }
)


# Rank
dls <- sort(dls, decreasing = TRUE)
top <- 5000

missedPackages <- names(dls[1:top])

for (i in 1:length(missedPackages))
{
  pkgName <- missedPackages[i]
  install.packages(
    pkgName, 
    upgrade = "never",
    quiet = TRUE,
    Ncpus = 2
  )
}
print("END")
