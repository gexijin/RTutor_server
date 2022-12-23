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

install.packages(list_packages)

remotes::install_github("gexijin/RTutor", upgrade = "never")

# Install top 1000 packages from CRAN
all <- available.packages()
all <- as.vector(all[, 1])
all <- sort(all)
cat("Total packages:", length(all))


# get download statistics for all CRAN packages
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")

remotes::install_github("r-hub/cranlogs")

# download the packages for the last 6 months
start_time <- Sys.time()

dls <- rep(0, length(all))
#dls <- rep(0, 100)
#for(i in 1:100) {
for(i in 1:length(all)) {
  if(i %% 100 == 0)
    cat("\n", i, "/", length(all))
  dls[i] <- sum(cranlogs::cran_downloads(
    package = all[i], 
    from = "2022-07-01", 
    to = "2022-12-15"
  )$count)
}

api_time <- difftime(
  Sys.time(),
  start_time,
  units = "secs"
)[[1]]

cat("\n", api_time/60, " minutes")
names(dls) <- all
#names(dls) <- all[1:100]
# Rank
dls<- sort(dls, decreasing = TRUE)
head(dls)

dls <- names(dls)

save.image("savedImage.Rdata")






start = 1
end = 1000

#  load("savedImage.Rdata")

for (i in start:min(end, length(dls))) {
  cat("\n", i, "/", end, dls[i], " ")   
  if(!(dls[i] %in% .packages(all.available = TRUE))) {  
    cat("Installing... ")    
    try(
      install.packages(
        dls[i], 
        upgrade = "never",
        quiet = TRUE,
        Ncpus = 2
      )
    )
  }
}

suc <- sum( dls[start:end] %in% .packages(all.available = TRUE))

cat("END\n", suc, "/", end - start + 1, " succeeded.")
cat("\nTotal installed:", length(.packages(all.available = TRUE) ),"\n")



# install bioconductor packages
# https://bioconductor.org/packages/stats/
if (!require("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager") 
  BiocManager::install(version = "3.16")
}


start <- 501
end <- 600

bioc <- read.table(
  "https://bioconductor.org/packages/stats/bioc/bioc_pkg_scores.tab", 
  header = TRUE
)

bioc <- bioc[order(-bioc$Download_score),]
dls <- bioc$Package

for (i in start:min(end, length(dls))) {
  cat("\n", i, "/", end, dls[i], " ")
  if(!(dls[i] %in% .packages(all.available = TRUE))) {
    cat("Installing... ")
    try(
      BiocManager::install(
        pkgs = dls[i], 
        upgrade = FALSE,
        ask = FALSE,
        upgrade = "never",
        quiet = TRUE,
        Ncpus = 2
      )
    )
  }
}
