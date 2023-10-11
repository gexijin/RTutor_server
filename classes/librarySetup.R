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
system("sudo apt install libtcl")
system("sudo apt install libtk")
system("sudo apt install libproj-dev")
system("sudo apt install libpq-dev gdal-bin libgdal-dev") #terra
system("apt-get update && sudo apt install default-jdk ") #installs Java for pathfindR 
system("sudo apt install libudunits2-dev libgsl-dev libglu1-mesa libsecret-1-0 librdf-dev") #choroplethr

# 2. Install remotes, cranlogs, and BiocManager------------------
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



# 3. get download statistics for all CRAN packages-------------------------
# download the packages stats for the last 6 months

#List of all CRAN packages
all <- available.packages()
all <- as.vector(all[, 1])
all <- sort(all)
cat("Total packages:", length(all))

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
cran_pkgs <- names(cran_packages_stats)



# 4. Install top CRAN packages----------------------------------------------

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
end <- 100
install_cran(cran_pkgs[start:end])
suc <- sum( cran_pkgs[start:end] %in% .packages(all.available = TRUE))
cat("END\n", suc, "/", end - start + 1, " succeeded.")
cat("\nTotal installed:", length(.packages(all.available = TRUE) ),"\n")

# list ones that are not installed.
cran_pkgs[!(cran_pkgs[start:end] %in% .packages(all.available = TRUE))]



# 5. Download statistics for bioconductor packages------------------------------------------

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
bioc <- rbind(bioc1, bioc2) #, bioc3)
bioc <- bioc[order(-bioc$Download_score),]
bioc <- bioc[!duplicated(bioc$Package),]

bioc_pkgs <- bioc$Package



#6 Install top Bioconductor packages ----------------------------------------------
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
          Ncpus = 2,
          INSTALL_opts = '--no-lock'
        )
      )
    }
  }
}


start = 1
end = 50
install_bioc(bioc_pkgs[start:end])

# 7. Install CRAN and Bioc packages

install_cran(cran_pkgs[1:2000])
install_bioc(bioc_pkgs[1:100])
# sudo docker commit 232342342342  webapp
# sudo docker system prune 

install_cran(cran_pkgs[2001:3000])
install_bioc(bioc_pkgs[106:200])
# sudo docker commit 232342342342  webapp
# sudo docker system prune 

install_cran(cran_pkgs[3001:4000])
install_bioc(bioc_pkgs[201:300])
# sudo docker commit 232342342342  webapp
# sudo docker system prune 

install_cran(cran_pkgs[4001:5000])
install_bioc(bioc_pkgs[301:400])
# sudo docker commit 232342342342  webapp
# sudo docker system prune 

install_cran(cran_pkgs[5001:6000])
install_bioc(bioc_pkgs[401:500])

install_cran(cran_pkgs[6001:7000])
install_bioc(bioc_pkgs[501:600])


install_cran(cran_pkgs[7001:8000])

install_cran(cran_pkgs[8001:10000])

install_cran(cran_pkgs[10001:12000]) #done




install_cran(cran_pkgs[12001:15000]) #done
install_bioc(bioc_pkgs[1001:2000])

# List packages with large storage
# cd /usr/local/lib/R/site-library
# du -hs * | sort -h -r | more

# Delete temp files in the container, older than 1 day
#sudo find /tmp -type f -atime +1 -delete

# remove some of the packages that are huge

length(.packages(all.available = TRUE))
}
