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

if(0){
# Install top 1000 packages from CRAN
all <- available.packages()
all <- as.vector(all[, 1])
all <- sort(all)
cat("Total packages:", length(all))


# get download statistics for all CRAN packages
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")

remotes::install_github("r-hub/cranlogs")

# download the packages stats for the last 6 months
start_time <- Sys.time()

dls <- rep(0, length(all))
#dls <- rep(0, 100)
#for(i in 1:100) {
for(i in 1:length(all)) {
  if(i %% 100 == 0)
    cat("\n", i, "/", length(all))
  dls[i] <- sum(cranlogs::cran_downloads(
    package = all[i],
    from = "2023-01-01",
    to = "2023-06-15"
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
cran_packages <- dls

dls <- names(dls)

save.image("savedImage.Rdata")

system("sudo apt install libbz2-dev")
system("sudo apt install libclang-dev")
system("sudo apt install libglpk-dev") #igraph

#CRAN finished 1-6000  12/24/2022
start <- 1
end <- 1000

#  load("savedImage.Rdata")


# install a list of packages from CRAN
install <- function(pkgs){
  for (i in 1:length(pkgs)) {
    cat("\n", i, "/", length(pkgs), pkgs[i], " ")

    # already installed?
    if(!(dls[i] %in% .packages(all.available = TRUE))) {
      cat("Installing... ")
      try(
        install.packages(
          pkgs[i],
          upgrade = "never",
          quiet = TRUE,
          Ncpus = 2
        )
      )
    }
  }
}

suc <- sum( dls[start:end] %in% .packages(all.available = TRUE))

cat("END\n", suc, "/", end - start + 1, " succeeded.")
cat("\nTotal installed:", length(.packages(all.available = TRUE) ),"\n")

# list ones that are not installed.


 dls[!(dls[start:end] %in% .packages(all.available = TRUE))]




# install bioconductor packages
# https://bioconductor.org/packages/stats/
if (!require("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager") 
  BiocManager::install(version = "3.17")
}





start <- 1
end <- 500

bioc <- read.table(
  # software packages; finished 1-500
  "https://bioconductor.org/packages/stats/bioc/bioc_pkg_scores.tab",

  # annotation packages; finished 1-30
#  "https://bioconductor.org/packages/stats/data-annotation/annotation_pkg_scores.tab",

   #experiment data package; finished 1-15
 # "https://bioconductor.org/packages/stats/data-experiment/experiment_pkg_scores.tab",

  header = TRUE
)

bioc <- bioc[order(-bioc$Download_score),]
dls <- bioc$Package


# install a list of packages from Bioconductor
install_bioc <- function(pkgs) {
  for (i in 1:length(pkgs)) {
    cat("\n", i, "/", length(pkgs), pkgs[i], " ")

    # already installed?
    if(!(dls[i] %in% .packages(all.available = TRUE))) {
      cat("Installing... ")
      try(
        BiocManager::install(
          pkgs = pkgs[i],
          upgrade = FALSE,
          ask = FALSE,
          upgrade = "never",
          quiet = TRUE,
          Ncpus = 2
        )
      )
    }
  }
}

install_bioc(dls[1:100])




}
