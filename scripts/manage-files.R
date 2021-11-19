# Copy notebooks files
l <- list.files("notebooks", "*.html|*.Rmd|*.rds|*.json|*.R", full.names = T)

for(from in l) {
  fileName <- gsub("^.*/(.*)$", "\\1", from)
  to <- file.path("../datagistips.github.io/dataviz-masterclass/notebooks/", fileName)
  file.copy(from, to, overwrite = T)
}

# Copy files dir.
file.copy("notebooks/files", 
          "../datagistips.github.io/dataviz-masterclass/notebooks/", 
          recursive = TRUE, overwrite = T)

# Copy archives dir.
file.copy("notebooks/archives", 
          "../datagistips.github.io/dataviz-masterclass/notebooks/", 
          recursive = TRUE, overwrite = T)
