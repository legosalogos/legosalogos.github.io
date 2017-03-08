other.dir <- getwd()


KnitPost <- function(input, base.url = "/") {
    require(knitr)
    opts_knit$set(base.url = base.url)
    base <- sub(".Rmd$", "", basename(input), "/")
    # fig.path <- paste0("figure/", base, "/")
    # opts_chunk$set(fig.path = fig.path)
    render_jekyll()
    out <- paste0("_posts/", base, ".md")
    knit(input, envir = parent.frame(), output = out)
}


sourcefiles <- list.files("_source", pattern = "*.Rmd" )
sourcefiles <- stringi::stri_replace(sourcefiles, "", regex = ".Rmd")

for (i in seq_along(sourcefiles)) {
    file <- paste0(normalizePath(dirname(sourcefiles[i])), "/_source/", sourcefiles[i], ".Rmd")
    outfile <- paste0(normalizePath(dirname(sourcefiles[i])), "/_posts/", sourcefiles[i], ".md")
    
    if (file.mtime(outfile) < file.mtime(file)) {
        KnitPost(file)
    }
}

setwd(other.dir)
