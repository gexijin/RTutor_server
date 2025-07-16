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
system("sudo apt install libudunits2-dev libgsl-dev libglu1-mesa libsecret-1-0 librdf-dev libglpk40") #choroplethr
system(" sudo apt-get install -y libfftw3-dev tcl-dev tk-dev")
system("sudo apt install libmagick++-dev") #magick
sudo apt-get install -y 
# 2. Install remotes, cranlogs, and BiocManager------------------
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")
if (!require("cranlogs", quietly = TRUE))
remotes::install_github("r-hub/cranlogs")




# 3. get download statistics for all CRAN packages-------------------------
# download the packages stats for the last 6 months

# ------------------------------------------------------------
# Read CRAN-package download counts from DataScienceMeta
# ------------------------------------------------------------
# packages you need
required <- c("rvest", "dplyr", "stringr", "readr")
invisible(lapply(required[!required %in% installed.packages()], install.packages))
library(rvest)
library(dplyr)
library(stringr)
library(readr)   # for parse_number

# URL of the ranking table
url <- "https://www.datasciencemeta.com/rpackages"

# ------------------------------------------------------------------
# 1. read the page – rvest::read_html() works because the table
#    is rendered server-side (no JavaScript needed) :contentReference[oaicite:0]{index=0}
# ------------------------------------------------------------------
page <- read_html(url)

# ------------------------------------------------------------------
# 2. extract the first/only table and coerce into a data frame
# ------------------------------------------------------------------
raw_tbl <- page %>%
  html_element("table") %>%   # or html_nodes("table")[1] prior to rvest 1.0
  html_table(fill = TRUE)

# ------------------------------------------------------------------
# 3. tidy it up
# ------------------------------------------------------------------
download_stats <- raw_tbl %>%
  rename(
    rank     = 1,   # column headings are “Rank”, “Package”, “Downloads”
    package  = 2,
    downloads = 3
  ) %>%
  mutate(
    rank      = as.integer(rank),
    downloads = parse_number(downloads)    # strip commas & make numeric
  ) %>%
  arrange(rank)

# ------------------------------------------------------------------
# 4. quick check
# ------------------------------------------------------------------
print(head(download_stats, 10))
cran_pkgs <- download_stats$package

if(0) {
  #List of all CRAN packages
  all <- available.packages()
  all <- as.vector(all[, 1])
  all <- sort(all)
  cat("Total packages:", length(all))

  start_time <- Sys.time()

  dls <- rep(0, length(all))
  #dls <- rep(0, 100)
  #for(i in 1:100) {

  #if RDS file exists, load it
  if (file.exists("cran_downloads.rds")) {
    dls <- readRDS("cran_downloads.rds")
    cat("\nLoaded existing download stats from cran_downloads.rds\n")
  } else {
    for(i in 1:length(all)) {
      if(i %% 500 == 0)
        cat("\n", i, "/", length(all))
        Sys.sleep(5) # to avoid API rate limit
      dls[i] <- sum(cranlogs::cran_downloads(
        package = all[i],
        from = "2025-05-01",
        to = "2025-07-10"
      )$count)
    }
    names(dls) <- all
    dls<- sort(dls, decreasing = TRUE)

    # save as RDS file
    saveRDS(dls, "cran_downloads.rds")
  }

  api_time <- difftime(
    Sys.time(),
    start_time,
    units = "secs"
  )[[1]]

  cat("\n", api_time/60, " minutes")

  #names(dls) <- all[1:100]
  # Rank
  head(dls)
  cran_packages_stats <- dls
  cran_pkgs <- names(cran_packages_stats)

}

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

# install first 100 packages
start <- 1; end <- 100
install_cran(cran_pkgs[start:end])
suc <- sum( cran_pkgs[start:end] %in% .packages(all.available = TRUE))
cat("END\n", suc, "/", end - start + 1, " succeeded.")
cat("\nTotal installed:", length(.packages(all.available = TRUE) ),"\n")


# install the rest of the packages in batches of 1000
for ( i in 1:24) {
  install_cran(cran_pkgs[((i-1)*1000+1):(i*1000)])
  cat("\n", i, "\tTotal installed:", length(.packages(all.available = TRUE) ),"\n")
  # stop by 3 seconds
  Sys.sleep(3)
}


# list ones that are not installed.
cran_pkgs[!(cran_pkgs[1:1000] %in% .packages(all.available = TRUE))]

listA <- cran_pkgs[3001:6000]
failed_pkgs <- listA[!(listA %in% .packages(all.available = TRUE))]
failed_pkgs
install.packages(failed_pkgs, upgrade = "never")



# 5. Download statistics for bioconductor packages------------------------------------------


if (!require("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager") 
  BiocManager::install(version = "3.21")
}
# https://bioconductor.org/packages/stats/



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
          Ncpus = 3,
          INSTALL_opts = '--no-lock'
        )
      )
    }
  }
}

# total 5600 packages
# install first 5 packages
start = 1
end = 5
install_bioc(bioc_pkgs[start:end])

# install the rest of the packages in batches of 100
for ( i in 1:40) {
  install_bioc(bioc_pkgs[((i-1)*100+1):(i*100)])
  # stop by 3 seconds
  Sys.sleep(30)
  cat("\n", i, "\tTotal installed:", length(.packages(all.available = TRUE)), "\n")
}



# 7. Install CRAN and Bioc packages


# List packages with large storage
# cd /usr/local/lib/R/site-library
# du -hs * | sort -h -r | more

# Delete temp files in the container, older than 1 day
#sudo find /tmp -type f -atime +1 -delete

# remove some of the packages that are huge

length(.packages(all.available = TRUE))



# 8. Install Python packages ---------------------------------------------
library(reticulate)
library(readr)
library(dplyr)

env <- "r-reticulate"

# Create env if it doesn't exist, then activate it
if (!env %in% conda_list()$name) {
  message("Creating conda environment '", env, "' …")
  conda_create(envname = env)
}
use_condaenv(env, required = TRUE)

# ---- fetch the package list ----
csv_url <- "https://hugovk.github.io/top-pypi-packages/top-pypi-packages.csv"
tmpfile <- tempfile(fileext = ".csv")
download.file(csv_url, tmpfile, mode = "wb")

py_packages <- read_csv(tmpfile, show_col_types = FALSE) %>% 
  pull(project)

targets <- py_packages[21:50]  # top 2000 packages


install_python_packages <- function(targets, env = "r-reticulate", batch_size = 5) {
  # ---- helper: current inventory ----
  installed_pkgs <- function() {
    py_list_packages(envname = env)$package %>% tolower()
  }

  have_now <- installed_pkgs()
  length(have_now) %>% 
    message(glue::glue("Currently installed packages in '{env}': {length(have_now)}"))

  # ---- batching ----
  batches         <- split(targets, ceiling(seq_along(targets) / batch_size))
  total_batches   <- length(batches)

  installed_count <- 0L
  failed_pkgs     <- character()

  for (i in seq_along(batches)) {
    todo <- setdiff(batches[[i]], have_now)   # skip what we already have
    if (length(todo) == 0) {
      message(glue::glue("Batch {i}/{total_batches}: nothing new, skipping."))
    } else {
      message(glue::glue("\nBatch {i}/{total_batches} | Installing {length(todo)} pkgs …"))

      # Snapshot before install so we can detect what really succeeded
      before <- have_now

      tryCatch(
        {
          py_install(todo,
                     envname     = env,
                     pip         = TRUE,
                     pip_options = c("--quiet", "--no-input",
                                     "--disable-pip-version-check"))
        },
        error = function(e) {
          warning("  !! pip error: ", conditionMessage(e))
        }
      )

      # Refresh inventory & book-keeping
      have_now <- installed_pkgs()
      newly_added <- setdiff(have_now, before)
      failed_this <- setdiff(todo, newly_added)

      installed_count <- installed_count + length(newly_added)
      failed_pkgs     <- union(failed_pkgs, failed_this)

      message(glue::glue("  ✓ Done. Installed {length(newly_added)} new; ",
                   "{length(failed_this)} failed."))
    }

    if (i < total_batches) Sys.sleep(5)
  }

  # ---- summary ----
  message("\n=== Summary ===")
  message("Total requested : ", length(targets))
  message("Already present : ", length(targets) - installed_count - length(failed_pkgs))
  message("Newly installed : ", installed_count)
  message("Failed installs : ", length(failed_pkgs))

  if (length(failed_pkgs)) {
    cat("\nPackages that failed to install:\n",
        paste(sort(failed_pkgs), collapse = ", "), "\n")
  }
}

install_python_packages(py_packages[1:200])
install_python_packages(py_packages[2540:3500])  # install the rest in batches of 60
install_python_packages(py_packages[2601:2700])  # install the rest in batches

install_python_packages(py_packages[3000:10000])  # install the rest in batches of 60
}