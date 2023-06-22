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

if(0){  # Run these manually

#1. Install Linux libraries--------------------------------------
system("sudo apt install libbz2-dev")
system("sudo apt install libclang-dev")
system("sudo apt install libglpk-dev") #igraph


# 2. List of all CRAN packages--------------------------------------
all <- available.packages()
all <- as.vector(all[, 1])
all <- sort(all)
cat("Total packages:", length(all))



# 3. Install remotes, cranlogs, and BiocManager------------------
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")
if (!require("cranlogs", quietly = TRUE))
remotes::install_github("r-hub/cranlogs")

# install bioconductor packages

if (!require("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager") 
  BiocManager::install(version = "3.17")
}
# https://bioconductor.org/packages/stats/





# 4. get download statistics for all CRAN packages-------------------------
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
    to = "2023-06-21"
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
cran_packages_stats <- dls
cran_pkgs <- names(cran_packages)



# 5. Install top CRAN packages----------------------------------------------

# Function install a list of packages from CRAN
install_cran <- function(pkgs) {
  for (i in 1:length(pkgs)) {
    cat("\n", i, "/", length(pkgs), pkgs[i], " ")

    # already installed?
    if(!(pkgs[i] %in% .packages(all.available = TRUE))) {
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

start <- 1
end <- 10
install_cran(cran_pkgs[start:end])
suc <- sum( cran_pkgs[start:end] %in% .packages(all.available = TRUE))
cat("END\n", suc, "/", end - start + 1, " succeeded.")
cat("\nTotal installed:", length(.packages(all.available = TRUE) ),"\n")

# list ones that are not installed.
cran_pkgs[!(cran_pkgs[start:end] %in% .packages(all.available = TRUE))]



# 6. Download statistics for bioconductor packages------------------------------------------

bioc1 <- read.table(
  # software packages; finished 1-500
  "https://bioconductor.org/packages/stats/bioc/bioc_pkg_scores.tab",
  header = TRUE
)
bioc2 <- read.table(
  # annotation packages; finished 1-30
  "https://bioconductor.org/packages/stats/data-annotation/annotation_pkg_scores.tab",
  header = TRUE
)

bioc3 <- read.table(
   #experiment data package; finished 1-15
  "https://bioconductor.org/packages/stats/data-experiment/experiment_pkg_scores.tab",
  header = TRUE
)
bioc <- rbind(bioc1, bioc2, bioc3)
bioc <- bioc[order(-bioc$Download_score),]
bioc <- bioc[!duplicated(bioc$Package),]

bioc_pkgs <- bioc$Package



#7 Install top Bioconductor packages ----------------------------------------------
# install a list of packages from Bioconductor
install_bioc <- function(pkgs) {
  for (i in 1:length(pkgs)) {
    cat("\n", i, "/", length(pkgs), pkgs[i], " ")

    # already installed?
    if(!(pkgs[i] %in% .packages(all.available = TRUE))) {
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


start = 1
end = 50
install_bioc(bioc_pkgs[start:end])


# 8. Install CRAN and Bioc packages

install_cran(cran_pkgs[1:2000])
system("sudo docker commit 7c3b94767cce webapp")

install_bioc(bioc_pkgs[1:100])
system("sudo docker commit 7c3b94767cce webapp")


install_cran(cran_pkgs[1:4000])
system("sudo docker commit 7c3b94767cce webapp")

install_bioc(bioc_pkgs[1:200])
system("sudo docker commit 7c3b94767cce webapp")



}
