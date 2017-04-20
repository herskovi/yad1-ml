#install.packages("dplyr")
install.packages('bindrcpp', dependencies=TRUE)
install.packages('devtools')
devtools::install_github("rstudio/httpuv")
devtools::install_github("assertthat")
devtools::install_github("hadley/lazyeval")
devtools::install_github("hadley/dplyr")
devtools::install_github("hadley/bigrquery")
devtools::install_github("rstudio/httpuv")

devtools::install_github("cloudyr/googleComputeEngineR")
library(bigrquery)



install.packages('googleComputeEngineR', dependencies=TRUE)
library(googleComputeEngineR)
library(bigrquery)
library('devtools')
library(httpuv)
options(httr_oob_default=TRUE)
Sys.setenv(GCE_AUTH_FILE="/Users/admin/Documents/yad2-ml/yad1-ml/key.json")

library(googleAuthR)
service_token <- gar_auth_service(json_file="/Users/admin/Documents/yad2-ml/yad1-ml/key.json")


projectId <- "yad2-analytics" # put your projectID here
df2= NULL

gce_global_project(project = projectId)
gce_global_zone("europe-west1-b")

options (java.parameters = "-Xmx8192m" )
options(digits=6)
options(httr_oob_default=TRUE)



sqlSuccess <- "SELECT  * FROM [yad2-analytics:1185028.results_20170316_175100] where Success = 1 LIMIT 1000"
sqlFailure <- "SELECT  * FROM [yad2-analytics:1185028.results_20170316_175100] where Success = 0 and isNadlanShowPhone=1"
df <- query_exec(sqlSuccess, project = projectId, max_pages = Inf)
df2 <- query_exec(sqlFailure, project = projectId, max_pages = Inf)
df3<- rbind(df2,df)


gce_get_global_project()
zone = gce_get_global_zone()

#vm <- gce_vm_create(name = "test-vm2", predefined_type = "f1-micro", metadata = list(start_date = as.character(Sys.Date())))

#Stop Instance
job <- gce_vm_stop("test-vm2")
ghost <-   gce_vm("test-vm2")

#ghost <-   gce_vm("test-vm2", image_project = "google-containers", image_family = "gci-stable", predefined_type = "f1-micro")
vm <- gce_vm(template = "rstudio", name = "rstudio-server", username = "swc", password = "swc1234")
       
#ghost <-   gce_vm("yad1-vm", image_project = "google-containers", image_family = "gci-stable", predefined_type = "f1-micro")

#master <- gce_vm("yad1-vm-master", predefined_type = "n1-standard-1", template = "rstudio", dynamic_image = gce_tag_container("cron-master"), username = "Moshe@swc.co.il",  password = "moshe1977")
