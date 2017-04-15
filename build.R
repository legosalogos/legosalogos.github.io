other.dir <- getwd()


KnitPost <- function(input, type = "post", base.url = "/") {
    require(knitr)
    opts_knit$set(base.url = base.url)
    base <- sub(".Rmd$", "", basename(input), "/")
    # fig.path <- paste0("figure/", base, "/")
    # opts_chunk$set(fig.path = fig.path)
    render_jekyll()
    out <- paste0("_", type, "s/", base, ".md")
    knit(input, envir = parent.frame(), output = out)
}


sourcefiles <- list.files("_source", pattern = "*.Rmd" )
sourcefiles <- stringi::stri_replace(sourcefiles, "", regex = ".Rmd")

for (i in seq_along(sourcefiles)) {
    file <- paste0(normalizePath(dirname(sourcefiles[i])), "/_source/", sourcefiles[i], ".Rmd")
    outfile <- paste0(normalizePath(dirname(sourcefiles[i])), "/_posts/", sourcefiles[i], ".md")
    draftfile <- paste0(normalizePath(dirname(sourcefiles[i])), "/_drafts/", sourcefiles[i], ".md")
    
    publish <- FALSE
    # Si el post existe pero es más viejo.
    if (file.exists(outfile) & file.mtime(outfile) < file.mtime(file)) {
        KnitPost(file, "post")
    # O si no existe en post y, o no existe en drafts o el draft es viejo
    } else if (!file.exists(outfile) & 
               (!file.exists(draftfile) | file.mtime(draftfile) < file.mtime(file))) {
        KnitPost(file, "draft")
    }
    
}

setwd(other.dir)
