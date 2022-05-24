library(remotes)
remotes::install_github("Ironholds/WikipediR")
library(WikipediR)
library(jsonlite)

  
  ls("package:WikipediR")
  wp_si =page_content("en","wikipedia", page_name = "Social inequality")
  wp_si= page_content("en", "wikipedia", page_id = as.numeric(wp_content[["parse"]][["pageid"]],as_wikitext = TRUE, clean_response = TRUE))
  
  wp_si_hist =list()
  more=T
  iteration=1
  wp_si_hist[[iteration]] =  revision_content("en","wikipedia", revisions = as.numeric(wp_si[["parse"]][["revid"]]))
  save=jsonlite::toJSON(wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]])
  jsonlite::write_json(x = save, path=paste("./data/id_",wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["revid"]],"_ts_",wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["timestamp"]],".json",sep = ""))
  
  test=jsonlite::fromJSON(jsonlite::fromJSON(txt = readLines(paste("./data/id_",wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["revid"]],"_ts_",wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["timestamp"]],".json",sep = ""),encoding = "UTF-8")),flatten = F)

while(more==T & !is.null(wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["parentid"]]) ){
  wp_si_hist[[iteration+1]]=revision_content("en","wikipedia", revisions = as.numeric(wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["parentid"]]))
  if(!is.null(wp_si_hist[[iteration+1]])){
  iteration=iteration+1
  save=jsonlite::toJSON(wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]])
  jsonlite::write_json(x = save, path=paste("./data/id_",wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["revid"]],"_ts_",wp_si_hist[[iteration]][["query"]][["pages"]][["14130192"]][["revisions"]][[1]][["timestamp"]],".json",sep = ""))
  print(iteration)
  Sys.sleep(5)}else{
    more=F
    print("stopped at iteration")
    print(iteration+1)
  }
  
}

